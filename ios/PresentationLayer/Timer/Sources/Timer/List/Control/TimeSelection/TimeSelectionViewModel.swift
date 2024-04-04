//
//  Created by Tomáš Batěk on 28.03.2024
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

protocol TimeSelectionViewModelDelegate: AnyObject {
    func didConfirmSelection(start: Date, end: Date)
}

final class TimeSelectionViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Stored properties
    
    weak var delegate: TimeSelectionViewModelDelegate?
    
    static private let minDate = Date.distantPast
    static private let maxDate = Date.distantFuture
    
    // MARK: - Init
    
    init(
        initialStart: Date?,
        initialEnd: Date?,
        flowController: FlowController? = nil
    ) {
        self.flowController = flowController
        super.init()
        
        onStartChange(initialStart ?? .now)
        onEndChange(initialEnd ?? .now)
    }
    
    // MARK: - Lifecycle
    
    // MARK: - State
    
    struct State {
        var start: Date = .now
        var startRange: ClosedRange<Date> = minDate...maxDate
        var end: Date = .now
        var endRange: ClosedRange<Date> = minDate...maxDate
        var formattedLength: String?
    }
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Intent
    
    enum Intent {
        case onStartChange(Date)
        case onEndChange(Date)
        case save
        case dismiss
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .onStartChange(date): onStartChange(date)
            case let .onEndChange(date): onEndChange(date)
            case .save: save()
            case .dismiss: dismiss()
            }
        })
    }
    
    // MARK: - Private
    
    private func onStartChange(_ start: Date) {
        state.start = start
        formatLength()
    }
    
    private func onEndChange(_ end: Date) {
        state.end = end
        formatLength()
    }
    
    private func formatLength() {
        guard state.start < state.end else {
            state.formattedLength = nil
            return
        }
        let formatter = Formatter.DateComponents.timer
        state.formattedLength = formatter.string(from: state.start, to: state.end)
    }
    
    private func save() {
        guard state.start < state.end else {
            snackState.currentData?.dismiss()
            snackState.showSnackSync(
                .error(
                    message: L10n.time_selection_view_wrong_range,
                    actionLabel: nil
                )
            )
            return
        }
        
        delegate?.didConfirmSelection(
            start: state.start,
            end: state.end
        )
        dismiss()
    }
    
    private func dismiss() {
        flowController?.handleFlow(TimerFlow.timeSelection(.dismiss))
    }
}
