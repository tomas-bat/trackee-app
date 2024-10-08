//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain
import SharedDomainMocks
import UniformTypeIdentifiers

final class TimerListViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Constants
    
    private let timerInterval: TimeInterval = 1
    private let entryPagingLimit = KotlinInt(int: 10)
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getTimerEntriesUseCase) private var getTimerEntriesUseCase
    @Injected(\.getTimerSummariesUseCase) private var getTimerSummariesUseCase
    @Injected(\.getTimerDataPreviewUseCase) private var getTimerDataPreviewUseCase
    @Injected(\.updateTimerDataUseCase) private var updateTimerDataUseCase
    @Injected(\.addTimerEntryUseCase) private var addTimerEntryUseCase
    @Injected(\.deleteTimerEntryUseCase) private var deleteTimerEntryUseCase
    
    // MARK: - Stored properties
    
    private var formatTimer: Timer?
    private var foregroundObserver: NSObjectProtocol?
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
        
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.executeTask(Task {
                await self?.fetchData(showLoading: false)
            })
        }
    }
    
    deinit {
        if let foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        startFormatTimer()
        
        let showLoading = !state.listData.hasData
                || !state.summaryViewData.hasData
                || !state.timerData.hasData

        executeTask(Task { await fetchData(showLoading: showLoading) })
    }
    
    override func onDisappear() {
        super.onDisappear()
        
        stopFormatTimer()
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var summaryViewData: ViewData<[TimerSummaryViewObject]> = .loading(mock: .stub)
        var listData: ViewData<[TimerEntryGroup]> = .loading(mock: .stub)
        var timerData: ViewData<TimerDataPreview> = .loading(mock: .stub)
        var manualTimerEnd: Date?
        var formattedLength: String?
        var formattedInterval: TimerEntryInterval?
        var deletingEntryId: String?
        var canLoadMoreData = true
        var alertData: AlertData?
        
        var controlLoading = false
        var switchLoading = false
        var discardLoading = false
        var isFetchingMore = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        enum Sync {
            case onProjectClick
            case onStartEditClick
            case onTimeEditClick
            case onDescriptionChange(String?)
            case onEntryDelete(id: String)
            case onEntryCopyDescription(id: String)
            case onEntryEdit(id: String)
            case changeAlertData(to: AlertData?)
        }
        
        enum Async {
            case tryAgain
            case onControlClick
            case onSwitchClick
            case onDeleteClick
            case onDescriptionSubmit
            case onEntryContinue(id: String)
            case onFetchMore
        }
        
        case sync(Sync)
        case async(Async)
    }
    
    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(intent):
            switch intent {
            case .onProjectClick: onProjectClick()
            case .onStartEditClick: onStartEditClick()
            case .onTimeEditClick: onTimeEditClick()
            case let .onDescriptionChange(description): onDescriptionChange(description)
            case let .onEntryDelete(id): onEntryDelete(id: id)
            case let .onEntryCopyDescription(id): onEntryCopyDescription(id: id)
            case let .onEntryEdit(id): onEntryEdit(id: id)
            case let .changeAlertData(data): state.alertData = data
            }
        case let .async(intent):
            executeTask(Task {
                switch intent {
                case .tryAgain: await fetchData()
                case .onControlClick: await onControlClick()
                case .onSwitchClick: await onSwitchClick()
                case .onDeleteClick: await discardTimer()
                case .onDescriptionSubmit: await updateTimerData()
                case let .onEntryContinue(id): await onEntryContinue(id: id)
                case .onFetchMore: await fetchMoreEntries()
                }
            })
        }
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = true) async {
        if showLoading {
            state.listData = .loading(mock: .stub)
            state.summaryViewData = .loading(mock: .stub)
            state.timerData = .loading(mock: .stub)
        }
        
        let tasks = [
            executeTask(Task { await fetchEntries() }),
            executeTask(Task { await fetchSummaries() }),
            executeTask(Task { await fetchTimer() })
        ]
        
        for task in tasks {
            await task.value
        }
    }
    
    private func fetchEntries() async {
        await execute {
            let params = GetTimerEntriesUseCaseParams(limit: entryPagingLimit)
            let groups: [TimerEntryGroup] = try await getTimerEntriesUseCase.execute(params: params)
            state.listData = .data(groups)
            state.canLoadMoreData = groups.flatMap { $0.entries }.count == entryPagingLimit.int
        } onError: { error in
            state.listData = .error(error)
        }
    }
    
    private func fetchMoreEntries() async {
        guard let currentGroups = state.listData.data,
              let firstEntryStart = currentGroups.first?.entries.first?.startedAt else { return }
        
        state.isFetchingMore = true
        defer { state.isFetchingMore = false }
        
        await execute {
            let params = GetTimerEntriesUseCaseParams(startAfter: firstEntryStart, limit: entryPagingLimit)
            let fetchedGroups: [TimerEntryGroup] = try await getTimerEntriesUseCase.execute(params: params)
            
            var newGroups: [TimerEntryGroup] = []
            
            // Handle overlapping group
            if let firstOfCurrent = currentGroups.first,
               let lastOfNew = fetchedGroups.last,
               firstOfCurrent.date == lastOfNew.date {
                newGroups.append(contentsOf: fetchedGroups.dropLast())
                
                var interval: KotlinLong? {
                    if lastOfNew.interval == nil && firstOfCurrent.interval == nil { return nil }
                    return KotlinLong(value: ((lastOfNew.interval?.int ?? 0) + (firstOfCurrent.interval?.int ?? 0)).int64)
                }
                
                newGroups.append(TimerEntryGroup(
                    date: firstOfCurrent.date,
                    interval: interval,
                    entries: lastOfNew.entries + firstOfCurrent.entries,
                    isFullyLoaded: lastOfNew.isFullyLoaded
                ))
                
                newGroups.append(contentsOf: currentGroups.dropFirst())
            } else {
                newGroups.append(contentsOf: fetchedGroups)
                if let firstOfCurrent = currentGroups.first, !firstOfCurrent.isFullyLoaded {
                    firstOfCurrent.isFullyLoaded = true
                }
                newGroups.append(contentsOf: currentGroups)
            }
            
            
            state.listData = .data(newGroups)
            
            state.canLoadMoreData = fetchedGroups.flatMap { $0.entries }.count == entryPagingLimit.int
        } onError: { error in
            state.listData = .error(error)
        }
    }
    
    private func fetchSummaries() async {
        await execute {
            let summaries: [TimerSummary] = try await getTimerSummariesUseCase.execute()
            let viewObjects = summaries.map { summary in
                if state.timerData.data?.status == .active,
                   state.timerData.data?.type == .timer,
                   let start = state.timerData.data?.startedAt?.asDate {
                    return summary.asViewObject.adding(start.distance(to: .now))
                }
                
                return summary.asViewObject
            }
            
            state.summaryViewData = .data(viewObjects)
        } onError: { _ in
            state.summaryViewData = .empty(.noData)
        }
    }
    
    private func fetchTimer() async {
        await execute {
            let timer: TimerDataPreview = try await getTimerDataPreviewUseCase.execute()
            state.timerData = .data(timer)
            
            startFormatTimer()
        } onError: { _ in
            state.timerData = .empty(.noData)
        }
    }
    
    private func onControlClick() async {
        guard let data = state.timerData.data else { return }
        
        state.controlLoading = true
        defer { state.controlLoading = false }
        
        await execute {
            switch (data.type, data.status) {
            case (.timer, .off):
                await onStartChange(Date.now, skipUpdate: true)
                await onEndChange(nil, skipUpdate: true)
                changeTimerStatus(to: .active)
                startFormatTimer()
                await updateTimerData()
            case (.timer, .active):
                stopFormatTimer()
                try await saveNewEntry(with: data, endedAt: .now)
                await onStartChange(nil, skipUpdate: true)
                await onEndChange(nil, skipUpdate: true)
                changeTimerStatus(to: .off)
                await updateTimerData()
                await fetchData(showLoading: false)
            case (.manual, _):
                guard let end = state.manualTimerEnd, data.startedAt != nil else {
                    snackState.currentData?.dismiss()
                    await snackState.showSnack(.error(message: L10n.timer_view_time_range_missing, actionLabel: nil))
                    return
                }
                try await saveNewEntry(with: data, endedAt: end)
                await fetchData(showLoading: false)
            }
        } onError: { error in
            await fetchData(showLoading: false) // In case data is invalidated
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
            startFormatTimer() // In case something failed and the timer is still running
        }
    }
    
    private func discardTimer() async {
        state.discardLoading = true
        defer { state.discardLoading = false }
        
        stopFormatTimer()
        await onStartChange(nil, skipUpdate: true)
        await onEndChange(nil, skipUpdate: true)
        changeTimerStatus(to: .off)
        await updateTimerData()
    }
    
    private func changeTimerStatus(to status: TimerStatus) {
        guard let data = state.timerData.data else { return }
        state.timerData = .data(
            TimerDataPreview(
                copy: data,
                status: status
            )
        )
    }
    
    private func saveNewEntry(
        with data: TimerDataPreview,
        endedAt: Date
    ) async throws {
        guard let projectId = data.project?.id,
              let clientId = data.client?.id
        else {
            throw TimerError.projectNotSelected
        }
        
        guard let startedAt = data.startedAt else { return }
        
        let params = AddTimerEntryUseCaseParams(
            entry: NewTimerEntry(
                clientId: clientId,
                projectId: projectId,
                description: data.description_,
                startedAt: startedAt,
                endedAt: endedAt.asInstant
            )
        )
        
        // Clockify export errors are not fatal
        do {
            try await addTimerEntryUseCase.execute(params: params)
        } catch {
            guard error.isClockifyExportError else { throw error }
            snackState.currentData?.dismiss()
            snackState.showSnackSync(
                .error(
                    message: error.localizedDescription,
                    actionLabel: nil,
                    duration: 4
                )
            )
        }
    }
    
    private func onSwitchClick() async {
        guard let data = state.timerData.data else { return }
        
        state.switchLoading = true
        defer { state.switchLoading = false }
        
        let newType = data.type.switched
        
        var start: Date? {
            switch (newType, data.startedAt) {
            case (.manual, nil): Date.now
            case (.timer, _): nil
            default: data.startedAt?.asDate
            }
        }
        
        var end: Date? {
            switch (newType, state.manualTimerEnd) {
            case (.manual, nil): Date.now
            case (.timer, _): nil
            default: state.manualTimerEnd
            }
        }
        
        state.timerData = .data(
            TimerDataPreview(
                copy: data,
                type: newType
            )
        )
        
        await onStartChange(start, skipUpdate: true)
        await onEndChange(end, skipUpdate: true)
        await updateTimerData()
    }
    
    private func onStartEditClick() {
        flowController?.handleFlow(
            TimerFlow.list(
                .showStartTimeSelection(
                    initialStart: state.timerData.data?.startedAt?.asDate,
                    delegate: self
                )
            )
        )
    }
    
    private func onTimeEditClick() {
        flowController?.handleFlow(
            TimerFlow.list(
                .showTimeSelection(
                    initialStart: state.timerData.data?.startedAt?.asDate,
                    initialEnd: state.manualTimerEnd,
                    delegate: self
                )
            )
        )
    }
    
    private func onProjectClick() {
        flowController?.handleFlow(
            TimerFlow.list(
                .showProjectSelection(
                    selectedProjectId: state.timerData.data?.project?.id,
                    delegate: self
                )
            )
        )
    }
    
    private func onStartChange(_ date: Date?, skipUpdate: Bool = false) async {
        guard let data = state.timerData.data else { return }
        state.timerData = .data(
            TimerDataPreview(
                copy: data,
                startedAt: date?.asInstant,
                removeStartTime: date == nil
            )
        )
        formatInterval()
        
        guard !skipUpdate else { return }
        await updateTimerData()
    }
    
    private func onEndChange(_ date: Date?, skipUpdate: Bool = false) async {
        state.manualTimerEnd = date
        formatInterval()
        
        guard !skipUpdate else { return }
        await updateTimerData()
    }
    
    private func onDescriptionChange(_ description: String?) {
        guard let data = state.timerData.data else { return }
        state.timerData = .data(
            TimerDataPreview(
                copy: data,
                description: description
            )
        )
    }
    
    private func onProjectChange(_ project: ProjectPreview) async {
        guard let data = state.timerData.data else { return }
        state.timerData = .data(
            TimerDataPreview(
                copy: data,
                client: project.client,
                project: project.rawProject
            )
        )
        
        await updateTimerData()
    }
    
    private func formatInterval() {
        guard let start = state.timerData.data?.startedAt?.asDate,
              let end = state.manualTimerEnd
        else {
            state.formattedInterval = nil
            return
        }
        state.formattedInterval = TimerEntryInterval(start: start, end: end)
    }
    
    private func formatTime(from: Date) -> String? {
        let formatter = Formatter.DateComponents.timer
        return formatter.string(from: from, to: .now)
    }
    
    private func startFormatTimer() {
        formatTimer?.invalidate()
        
        guard state.timerData.data?.status == .active,
              state.timerData.data?.type == .timer,
              let start = state.timerData.data?.startedAt?.asDate
        else { return }
        
        formatTimer = Timer.scheduledTimer(
            withTimeInterval: timerInterval,
            repeats: true
        ) { [weak self] timer in
            guard let self else { return }
            state.formattedLength = formatTime(from: start)
            if let data = state.summaryViewData.data {
                state.summaryViewData = .data(data.map { $0.adding(start.distance(to: .now)) })
            }
        }
        
        formatTimer?.fire()
    }
    
    private func stopFormatTimer() {
        formatTimer?.invalidate()
    }
    
    private func updateTimerData() async {
        guard let rawTimerData = state.timerData.data?.rawTimerData else { return }
        
        await execute {
            let params = UpdateTimerDataUseCaseParams(timerData: rawTimerData)
            try await updateTimerDataUseCase.execute(params: params)
        } onError: { error in
            snackState.currentData?.dismiss()
            await snackState.showSnack(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func onEntryDelete(id: String) {
        state.alertData = AlertData(
            title: L10n.timer_view_delete_entry_alert_title,
            message: L10n.timer_view_delete_entry_alert_description,
            primaryAction: AlertData.Action(
                title: L10n.timer_view_entry_delete,
                style: .destruction,
                handler: { [weak self] in
                    self?.executeTask(Task {
                        await self?.deleteEntry(id: id)
                    })
                }
            ),
            secondaryAction: AlertData.Action(
                title: L10n.cancel,
                style: .cancel
            )
        )
    }
    
    private func deleteEntry(id: String) async {
        state.deletingEntryId = id
        defer {
            state.deletingEntryId = nil
        }
        
        await execute {
            let params = DeleteTimerEntryUseCaseParams(entryId: id)
            try await deleteTimerEntryUseCase.execute(params: params)
            await fetchData(showLoading: false)
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func onEntryContinue(id: String) async {
        state.controlLoading = true
        defer { state.controlLoading = false }
        
        guard let entry = state.listData.data?
                .flatMap({ $0.entries })
                .first(where: { $0.id == id }),
              let timerData = state.timerData.data
        else { return }
        
        state.timerData = .data(
            TimerDataPreview(
                copy: timerData,
                client: entry.client,
                project: entry.project,
                description: entry.description_
            )
        )
        
        switch (timerData.type, timerData.status) {
        case (.timer, .off):
            await onStartChange(Date.now, skipUpdate: true)
            await onEndChange(nil, skipUpdate: true)
            changeTimerStatus(to: .active)
            startFormatTimer()
        default: ()
        }
        
        await updateTimerData()
    }
    
    private func onEntryCopyDescription(id: String) {
        guard let description = state.listData.data?
                .flatMap({ $0.entries })
                .first(where: { $0.id == id })?
                .description_
        else { return }
        
        UIPasteboard.general.setValue(
            description,
            forPasteboardType: UTType.plainText.identifier
        )
        
        snackState.currentData?.dismiss()
        snackState.showSnackSync(.info(message: L10n.timer_view_entry_description_copied_to_clipboard))
    }
    
    private func onEntryEdit(id: String) {
        flowController?.handleFlow(TimerFlow.list(.showDetail(
            entryId: id,
            delegate: self
        )))
    }
}


// MARK: - ProjectSelectionViewModelDelegate

extension TimerListViewModel: ProjectSelectionViewModelDelegate {
    func didSelectProject(_ project: ProjectPreview) {
        executeTask(Task {
            await onProjectChange(project)
        })
    }
}

// MARK: - TimeSelectionViewModelDelegate

extension TimerListViewModel: TimeSelectionViewModelDelegate {
    func didConfirmSelection(start: Date, end: Date) {
        executeTask(Task {
            await onStartChange(start, skipUpdate: true)
            await onEndChange(end)
        })
    }
}

// MARK: - StartTimeSelectionViewModelDelegate

extension TimerListViewModel: StartTimeSelectionViewModelDelegate {
    func didConfirmSelection(start: Date) {
        executeTask(Task {
            await onStartChange(start)
            startFormatTimer()
        })
    }
}

// MARK: - TimerEntryDetailViewModelDelegate

extension TimerListViewModel: TimerEntryDetailFlowControllerDelegate {
    func didUpdateEntry() async {
        await fetchData(showLoading: false)
    }
}
