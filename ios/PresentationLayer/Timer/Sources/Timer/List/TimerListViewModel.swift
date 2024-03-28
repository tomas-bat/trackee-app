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
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .tryAgain: await fetchData()
            case .onProjectClick: flowController?.handleFlow(TimerFlow.list(.showProjectSelection))
            case .onControlClick: ()
            case .onSwitchClick: onSwitchClick()
            case .onDeleteClick: ()
            case .onTimeEditClick: onTimeEditClick()
            case let .onDescriptionChange(description): onDescriptionChange(description)
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData() async {
        guard !state.listData.hasData 
                || !state.summaryViewData.hasData
                || !state.timerData.hasData
        else { return }
        
        state.listData = .loading(mock: .stub)
        state.summaryViewData = .loading(mock: .stub)
        state.timerData = .loading(mock: .stub)
        
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
    
    private func onSwitchClick() {
        guard let data = state.timerData.data else { return }
        
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
        onStartChange(start)
        onEndChange(end)
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
    
    private func onStartChange(_ date: Date?) {
        guard let data = state.timerData.data else { return }
        state.timerData = .data(
            TimerDataPreview(
                copy: data,
                startedAt: date?.asInstant
            )
        )
        formatInterval()
    }
    
    private func onEndChange(_ date: Date?) {
        state.manualTimerEnd = date
        formatInterval()
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
}

// MARK: - TimeSelectionViewModelDelegate

extension TimerListViewModel: TimeSelectionViewModelDelegate {
    func didConfirmSelection(start: Date, end: Date) {
        onStartChange(start)
        onEndChange(end)
    }
}
