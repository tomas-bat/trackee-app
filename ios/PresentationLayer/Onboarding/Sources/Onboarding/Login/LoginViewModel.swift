//
//  Created by Petr Chmelar on 20.02.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain

final class LoginViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: Dependencies
    private weak var flowController: FlowController?
    
    @Injected(\.loginWithCredentialsUseCase) private var loginWithCredentialsUseCase

    init(flowController: FlowController?) {
        self.flowController = flowController
        super.init()
        
        if Environment.flavor == .debug && Environment.type == .alpha {
            
        }
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
    }
    
    // MARK: State
    
    @Published private(set) var state: State = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()

    struct State {
        var email = ""
        var password = ""
        
        var isLoading = false
        
        var alert: AlertData?
    }
    
    // MARK: Intent
    enum Intent {
        case sync(Sync)
        case async(Async)
        
        enum Sync {
            case onEmailChange(to: String)
            case onPasswordChange(to: String)
        }
        
        enum Async {
            case onLoginTap
        }
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(syncIntent):
            switch syncIntent {
            case let .onEmailChange(email): state.email = email
            case let .onPasswordChange(password): state.password = password
            }
        case let .async(asyncIntent):
            executeTask(Task {
                switch asyncIntent {
                case .onLoginTap: await loginWithCredentials()
                }
            })
        }
    }
    
    // MARK: Private
    
    private func dismissAlert() {
        state.alert = nil
    }
    
    private func loginWithCredentials() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            let params = LoginWithCredentialsUseCaseParams(
                username: state.email,
                password: state.password
            )
            
            try await loginWithCredentialsUseCase.execute(params: params)
            
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.info(message: "Login Success"))
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
