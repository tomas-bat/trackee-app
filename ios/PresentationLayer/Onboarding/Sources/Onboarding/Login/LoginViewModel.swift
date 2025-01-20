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
    
    // MARK: - Constants
    
    private let messageDelay: TimeInterval = 0.5
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.loginWithCredentialsUseCase) private var loginWithCredentialsUseCase
    @Injected(\.loginWithProviderUseCase) private var loginWithProviderUseCase
    
    // MARK: - Stored properties
    
    private var message: String?
    
    // MARK: - Init

    init(
        message: String? = nil,
        flowController: FlowController?
    ) {
        self.flowController = flowController
        self.message = message
        super.init()
        
        if Utilities.Environment.type == .alpha, Utilities.Environment.flavor == .debug {
            state.email = "testaccount@domain.com"
            state.password = "sexhah-2noNje-baxpuc"
        }
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        if let message {
            Task.delayed(byTimeInterval: messageDelay) { [weak self] in
                guard !Task.isCancelled else { return }
                self?.snackState.currentData?.dismiss()
                self?.snackState.showSnackSync(.info(message: message))
                self?.message = nil
            }
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()

    struct State {
        var email = ""
        var password = ""
        
        var credentialsLoginLoading = false
        var appleLoginLoading = false
        
        var alert: AlertData?
    }
    
    // MARK: - Intent
    enum Intent {
        case sync(Sync)
        case async(Async)
        
        enum Sync {
            case onEmailChange(to: String)
            case onPasswordChange(to: String)
            case register
        }
        
        enum Async {
            case login
            case signInWithApple
        }
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(syncIntent):
            switch syncIntent {
            case let .onEmailChange(email): state.email = email
            case let .onPasswordChange(password): state.password = password
            case .register: register()
            }
        case let .async(asyncIntent):
            executeTask(Task {
                switch asyncIntent {
                case .login: await loginWithCredentials()
                case .signInWithApple: await signInWithApple()
                }
            })
        }
    }
    
    // MARK: - Private
    
    private func dismissAlert() {
        state.alert = nil
    }
    
    private func loginWithCredentials() async {
        state.credentialsLoginLoading = true
        defer { state.credentialsLoginLoading = false }
        
        await execute {
            let params = LoginWithCredentialsUseCaseParams(
                username: state.email,
                password: state.password
            )
            
            try await loginWithCredentialsUseCase.execute(params: params)
            
            flowController?.handleFlow(OnboardingFlow.login(.dismiss))
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(
                .error(
                    message: error.localizedDescription,
                    actionLabel: nil
                )
            )
        }
    }
    
    private func register() {
        flowController?.handleFlow(OnboardingFlow.login(.showRegistration))
    }
    
    private func signInWithApple() async {
        state.appleLoginLoading = true
        defer { state.appleLoginLoading = false }
        
        await execute {
            let params = LoginWithProviderUseCaseParams(
                type: .apple
            )
            try await loginWithProviderUseCase.execute(params: params)
            
            flowController?.handleFlow(OnboardingFlow.login(.dismiss))
        } onError: { error in
            if error.kmpErrorResult is AuthError.ExternalFlowCancelled { return }
            
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
