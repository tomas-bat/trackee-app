//
//  Created by Tomáš Batěk on 11.04.2024
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

protocol StartTimeSelectionViewModelDelegate: AnyObject {
    func didConfirmSelection(start: Date)
}

final class StartTimeSelectionViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Stored properties
    
    weak var delegate: StartTimeSelectionViewModelDelegate?
    
    static private let minDate = Date.distantPast
    static private let maxDate = Date.distantFuture
    
    // MARK: - Init
    
    init(
        initialStart: Date?,
        flowController: FlowController? = nil
    ) {
        self.flowController = flowController
        super.init()
        
        onStartChange(initialStart ?? .now)
    }
    
    // MARK: - Lifecycle
    
    // MARK: - State
    
    struct State {
        var start: Date = .now
        var startRange: ClosedRange<Date> = minDate...maxDate
    }
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Intent
    
    enum Intent {
        case onStartChange(Date)
        case save
        case dismiss
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .onStartChange(date): onStartChange(date)
            case .save: save()
            case .dismiss: dismiss()
            }
        })
    }
    
    // MARK: - Private
    
    private func onStartChange(_ start: Date) {
        state.start = start
    }
    
    private func save() {
        guard state.start < Date.now else {
            snackState.currentData?.dismiss()
            snackState.showSnackSync(
                .error(
                    message: L10n.start_time_selection_view_wrong_range,
                    actionLabel: nil
                )
            )
            return
        }
        
        delegate?.didConfirmSelection(start: state.start)
        dismiss()
    }
    
    private func dismiss() {
        flowController?.handleFlow(TimerFlow.startTimeSelection(.dismiss))
    }
}
