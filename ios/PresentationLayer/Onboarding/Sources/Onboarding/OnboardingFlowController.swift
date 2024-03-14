//
//  Created by Petr Chmelar on 04/02/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import SwiftUI
import UIKit
import UIToolkit

enum OnboardingFlow: Flow, Equatable {
    case login(Login)
    
    enum Login: Equatable {
        case dismiss
    }
}

public protocol OnboardingFlowControllerDelegate: AnyObject {
    func setupMain()
}

public final class OnboardingFlowController: FlowController {
    
    public weak var delegate: OnboardingFlowControllerDelegate?
    
    override public func setup() -> UIViewController {
        let vm = LoginViewModel(flowController: self)
        return BaseHostingController(rootView: LoginView(viewModel: vm))
    }
    
    override public func dismiss() {
        super.dismiss()
        delegate?.setupMain()
    }
    
    override public func handleFlow(_ flow: Flow) {
        guard let onboardingFlow = flow as? OnboardingFlow else { return }
        switch onboardingFlow {
        case .login(let loginFlow): handleLoginFlow(loginFlow)
        }
    }
}

// MARK: Login flow
extension OnboardingFlowController {
    func handleLoginFlow(_ flow: OnboardingFlow.Login) {
        switch flow {
        case .dismiss: dismiss()
        }
    }
}

