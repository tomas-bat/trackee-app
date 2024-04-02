//
//  Created by Petr Chmelar on 22.05.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit

final class ProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.logoutUseCase) private var logoutUseCase
    
    
    // MARK: - Init

    init(flowController: FlowController?) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()

    struct State {
    }
    
    // MARK: - Intent
    enum Intent {
        case logout
        case showClients
        case showProjects
    }

    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .logout: await logout()
            case .showClients: flowController?.handleFlow(ProfileFlow.overview(.showClients))
            case .showProjects: flowController?.handleFlow(ProfileFlow.overview(.showProjects))
            }
        })
    }
    
    // MARK: - Private
    
    private func logout() async {
        do {
            try await logoutUseCase.execute()
            flowController?.handleFlow(ProfileFlow.overview(.presentOnboarding))
        } catch {
            snackState.currentData?.dismiss()
            snackState.showSnackSync(
                .error(
                    message: error.localizedDescription,
                    actionLabel: nil
                )
            )
        }
    }
    
}
