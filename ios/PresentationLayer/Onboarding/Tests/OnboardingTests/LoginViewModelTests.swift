//
//  Created by Petr Chmelar on 07.03.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import DependencyInjection
import Factory
@testable import Onboarding
@testable import SharedDomain
import UIToolkit
import XCTest
import Combine

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    // MARK: Dependencies
    
    private let fc = FlowControllerMock<OnboardingFlow>(navigationController: UINavigationController())
    
    private var disposeBag = Set<AnyCancellable>()
    
//    private let loginUseCase = LoginUseCaseSpy()
//    private let trackAnalyticsEventUseCase = TrackAnalyticsEventUseCaseSpy()
    
    private func createViewModel() -> LoginViewModel {
        Container.shared.reset()
//        Container.shared.loginUseCase.register { self.loginUseCase }
//        Container.shared.trackAnalyticsEventUseCase.register { self.trackAnalyticsEventUseCase }
        
        let vm = LoginViewModel(flowController: fc)
        observeSnackState(vm: vm)
        
        return vm
    }
    
    private func observeSnackState(vm: LoginViewModel) {
        vm.snackState.$currentData.sink { snackState in
            if let snackState {
                snackState.dismiss()
            }
        }
        .store(in: &disposeBag)
    }

    // MARK: Tests
    
}
