//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import KMPSharedDomain

final class RegisterViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.registerUseCase) private var registerUseCase
    
    // MARK: - Stored properties
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var email = ""
        var newPassword = ""
        var verifyPassword = ""
        var isLoading = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        case sync(Sync)
        case async(Async)
        
        enum Sync {
            case onEmailChange(to: String)
            case onNewPasswordChange(to: String)
            case onVerifyPasswordChange(to: String)
        }
        
        enum Async {
            case register
        }
    }
    
    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(syncIntent):
            switch syncIntent {
            case let .onEmailChange(email): state.email = email
            case let .onNewPasswordChange(newPassword): state.newPassword = newPassword
            case let .onVerifyPasswordChange(verifyPassword): state.verifyPassword = verifyPassword
            }
        case let .async(asyncIntent):
            executeTask(Task {
                switch asyncIntent {
                case .register: await register()
                }
            })
        }
    }
    
    // MARK: - Private
    
    private func register() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            let params = RegisterUseCaseParams(
                username: state.email,
                newPassword: state.newPassword,
                verifyPassword: state.verifyPassword
            )
            
            try await registerUseCase.execute(params: params)
            
            flowController?.handleFlow(OnboardingFlow.register(.dismiss))
        } catch {
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.info(message: error.localizedDescription))
        }
    }
}
