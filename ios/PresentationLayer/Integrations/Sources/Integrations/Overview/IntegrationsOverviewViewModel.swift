//
//  Created by Tomáš Batěk on 19.04.2024
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

final class IntegrationsOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    @Injected(\.getIntegrationsUseCase) private var getIntegrationsUseCase
    
    private weak var flowController: FlowController?
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: !state.integrations.hasData)
        })
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var integrations: ViewData<[Integration]> = .loading(mock: .stub)
    }
    
    // MARK: - Intent
    
    enum Intent {
        case retry
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .retry: await fetchData(showLoading: true)
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool) async {
        if showLoading {
            state.integrations = .loading(mock: .stub)
        }
        
        do {
            let integrations: [Integration] = try await getIntegrationsUseCase.execute()
            
            if integrations.isEmpty {
                state.integrations = .empty(.noData)
            } else {
                state.integrations = .data(integrations)
            }
        } catch {
            state.integrations = .error(error)
        }
    }
}
