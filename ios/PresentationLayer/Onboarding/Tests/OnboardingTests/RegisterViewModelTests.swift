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
final class RegisterModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(
        navigationController: UINavigationController()
    )
    
    private let registerUseCaseMock = RegisterUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    
    private let loginWithCredentialsUseCaseMock = LoginWithCredentialsUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    
    private func createViewModel() -> RegisterViewModel {
        Container.shared.registerUseCase.register { self.registerUseCaseMock }
        
        return RegisterViewModel(flowController: flowController)
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
    
    func testOnNewPasswordChange() async {
        // given
        let vm = createViewModel()
        let password = String.randomString()
        
        // when
        vm.onIntent(.sync(.onNewPasswordChange(to: password)))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.newPassword, password)
    }
    
    func testOnVerifyPasswordChange() async {
        // given
        let vm = createViewModel()
        let password = String.randomString()
        
        // when
        vm.onIntent(.sync(.onVerifyPasswordChange(to: password)))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.verifyPassword, password)
    }
    
    func testRegister() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.async(.register))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .register(.dismiss))
    }
}
