//
//  Created by Tomáš Batěk on 20.04.2024
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

final class IntegrationExportViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Stored properties
    
    private let integrationType: IntegrationType
    
    // MARK: - Init
    
    init(
        integrationType: IntegrationType,
        flowController: FlowController? = nil
    ) {
        self.integrationType = integrationType
        self.flowController = flowController
    }
    
    // MARK: - Lifecycle
    
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var fromDate: Date = .now
        var toDate: Date = .now
        var exportLoading = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        case changeFromDate(to: Date)
        case changeToDate(to: Date)
        case export
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeFromDate(date): state.fromDate = date
            case let .changeToDate(date): state.toDate = date
            case .export: await export()
            }
        })
    }
    
    // MARK: - Private
    
    private func export() async {
        do {
            guard state.fromDate <= state.toDate else {
                throw IntegrationError.invalidDateRange
            }
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        snackState.currentData?.dismiss()
        snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
    }
}
