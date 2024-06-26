//
//  Created by Tomáš Batěk on 21.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
@testable import Onboarding
import Factory
import SharedDomain
import SharedDomainMocks
import UIToolkit
import XCTest
import DependencyInjection
import DependencyInjectionMocks
import Utilities

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(
        navigationController: UINavigationController()
    )
    
    private let loginWithCredentialsUseCaseMock = LoginWithCredentialsUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    
    private func createViewModel() -> LoginViewModel {
        Container.shared.loginWithCredentialsUseCase.register { self.loginWithCredentialsUseCaseMock }
        
        return LoginViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    func testOnEmailChange() async {
        // given
        let vm = createViewModel()
        let email = String.randomString()
        
        // when
        vm.onIntent(.sync(.onEmailChange(to: email)))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.email, email)
    }
    
    func testOnPasswordChange() async {
        // given
        let vm = createViewModel()
        let password = String.randomString()
        
        // when
        vm.onIntent(.sync(.onPasswordChange(to: password)))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.password, password)
    }
    
    func testRegister() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.sync(.register))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .login(.showRegistration))
    }
    
    func testLogin() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.async(.login))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .login(.dismiss))
    }
}
