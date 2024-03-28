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

final class TimerListViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Constants
    
    private let timerInterval: TimeInterval = 1
    
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
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        startFormatTimer()
        
        guard !state.listData.hasData
                || !state.summaryViewData.hasData
                || !state.timerData.hasData
        else { return }
        executeTask(Task { await fetchData() })
    }
    
    override func onDisappear() {
        super.onDisappear()
        
        stopFormatTimer()
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var summaryViewData: ViewData<[TimerSummary]> = .loading(mock: .stub)
        var listData: ViewData<[TimerEntryPreview]> = .loading(mock: .stub)
        var timerData: ViewData<TimerDataPreview> = .loading(mock: .stub)
        var manualTimerEnd: Date?
        var formattedLength: String?
        var formattedInterval: TimerEntryInterval?
        var deletingEntryId: String?
        
        var controlLoading = false
        var switchLoading = false
        var discardLoading = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        case tryAgain
        case onProjectClick
        case onControlClick
        case onSwitchClick
        case onDeleteClick
        case onTimeEditClick
        case onDescriptionChange(String?)
        case onDescriptionSubmit
        case onEntryDelete(id: String)
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .tryAgain: await fetchData()
            case .onProjectClick: onProjectClick()
            case .onControlClick: await onControlClick()
            case .onSwitchClick: await onSwitchClick()
            case .onDeleteClick: await discardTimer()
            case .onTimeEditClick: onTimeEditClick()
            case let .onDescriptionChange(description): onDescriptionChange(description)
            case .onDescriptionSubmit: await updateTimerData()
            case let .onEntryDelete(id): await onEntryDelete(id: id)
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = true) async {
        if showLoading {
            state.listData = .loading(mock: .stub)
            state.summaryViewData = .loading(mock: .stub)
            state.timerData = .loading(mock: .stub)
        }
        
        do {
            let entries: [TimerEntryPreview] = try await getTimerEntriesUseCase.execute()
            let summaries: [TimerSummary] = try await getTimerSummariesUseCase.execute()
            let timer: TimerDataPreview = try await getTimerDataPreviewUseCase.execute()
            
            state.listData = .data(entries)
            state.summaryViewData = .data(summaries)
            state.timerData = .data(timer)
            
            startFormatTimer()
        } catch {
            state.listData = .error(error)
            state.summaryViewData = .empty
            state.timerData = .empty
        }
    }
    
    private func onControlClick() async {
        guard let data = state.timerData.data else { return }
        
        state.controlLoading = true
        defer { state.controlLoading = false }
        
        switch (data.type, data.status) {
        case (.timer, .off):
            await onStartChange(Date.now, skipUpdate: true)
            await onEndChange(nil, skipUpdate: true)
            changeTimerStatus(to: .active)
            startFormatTimer()
            await updateTimerData()
        case (.timer, .active):
            stopFormatTimer()
            await saveNewEntry(with: data, endedAt: .now)
            await onStartChange(nil, skipUpdate: true)
            await onEndChange(nil, skipUpdate: true)
            changeTimerStatus(to: .off)
            await updateTimerData()
        case (.manual, _):
            guard let end = state.manualTimerEnd, data.startedAt != nil else {
                await snackState.showSnack(.error(message: L10n.timer_view_time_range_missing, actionLabel: nil))
                return
            }
            await saveNewEntry(with: data, endedAt: end)
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
    ) async {
        guard let projectId = data.project?.id,
              let clientId = data.client?.id,
              let startedAt = data.startedAt
        else { return }
        
        do {
            let params = AddTimerEntryUseCaseParams(
                entry: NewTimerEntry(
                    clientId: clientId,
                    projectId: projectId,
                    description: data.description_,
                    startedAt: startedAt,
                    endedAt: endedAt.asInstant
                )
            )
            try await addTimerEntryUseCase.execute(params: params)
            await fetchData(showLoading: false)
        } catch {
            await snackState.showSnack(.error(message: error.localizedDescription, actionLabel: nil))
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
        }
        
        formatTimer?.fire()
    }
    
    private func stopFormatTimer() {
        formatTimer?.invalidate()
    }
    
    private func updateTimerData() async {
        guard let rawTimerData = state.timerData.data?.rawTimerData else { return }
        
        do {
            let params = UpdateTimerDataUseCaseParams(timerData: rawTimerData)
            try await updateTimerDataUseCase.execute(params: params)
        } catch {
            await snackState.showSnack(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func onEntryDelete(id: String) async {
        state.deletingEntryId = id
        defer { state.deletingEntryId = nil }
        
        do {
            let params = DeleteTimerEntryUseCaseParams(entryId: id)
            try await deleteTimerEntryUseCase.execute(params: params)
            await fetchData(showLoading: false)
        } catch {
            await snackState.showSnack(.error(message: error.localizedDescription, actionLabel: nil))
        }
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
