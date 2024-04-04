//
//  Created by Petr Chmelar on 04/02/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import SwiftUI
import UIKit
import UIToolkit

enum OnboardingFlow: Flow, Equatable {
    case login(Login)
    case register(Register)
    
    enum Login: Equatable {
        case dismiss
        case showRegistration
    }
    
    enum Register: Equatable {
        case dismiss
        case pop
    }
}

public protocol OnboardingFlowControllerDelegate: AnyObject {
    func setupMain()
}

public final class OnboardingFlowController: FlowController {
    
    public weak var delegate: OnboardingFlowControllerDelegate?
    
    private let message: String?
    
    public init(
        message: String?,
        navigationController: UINavigationController
    ) {
        self.message = message
        super.init(navigationController: navigationController)
    }
    
    override public func setup() -> UIViewController {
        let vm = LoginViewModel(
            message: message,
            flowController: self
        )
        return BaseHostingController(rootView: LoginView(viewModel: vm))
    }
    
    override public func dismiss() {
        super.dismiss()
        delegate?.setupMain()
    }
    
    override public func handleFlow(_ flow: Flow) {
        guard let onboardingFlow = flow as? OnboardingFlow else { return }
        switch onboardingFlow {
        case let .login(loginFlow): handleLoginFlow(loginFlow)
        case let .register(registerFlow): handleRegisterFlow(registerFlow)
        }
    }
}

// MARK: Login flow
extension OnboardingFlowController {
    func handleLoginFlow(_ flow: OnboardingFlow.Login) {
        switch flow {
        case .dismiss: dismiss()
        case .showRegistration: showRegistration()
        }
    }
    
    private func showRegistration() {
        let vm = RegisterViewModel(flowController: self)
        let view = RegisterView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: Register flow
extension OnboardingFlowController {
    func handleRegisterFlow(_ flow: OnboardingFlow.Register) {
        switch flow {
        case .dismiss: dismiss()
        case .pop: pop()
        }
    }
}

