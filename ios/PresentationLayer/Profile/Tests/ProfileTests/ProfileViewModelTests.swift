//
//  Created by Tomáš Batěk on 21.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
@testable import Profile
import Factory
import SharedDomain
import SharedDomainMocks
import UIToolkit
import XCTest
import DependencyInjection
import DependencyInjectionMocks
import Utilities

@MainActor
final class ProfileViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProfileFlow>(
        navigationController: UINavigationController()
    )
    
    let logoutUseCaseMock = LogoutUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    let deleteUserUseCaseMock = DeleteUserUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    let getUserEmailUseCaseMock = GetUserEmailUseCaseMock(
        executeReturnValue:ResultSuccess(data: String.randomString() as NSString)
    )
    
    private func createViewModel() -> ProfileViewModel {
        Container.shared.logoutUseCase.register { self.logoutUseCaseMock }
        Container.shared.deleteUserUseCase.register { self.deleteUserUseCaseMock }
        Container.shared.getUserEmailUseCase.register { self.getUserEmailUseCaseMock }
        
        return ProfileViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    func testLogout() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.logout)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .overview(.presentOnboarding(message: L10n.login_view_logged_out_info))
        )
    }
    
    func testShowClients() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showClients)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .overview(.showClients))
    }
    
    func testShowProjects() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showProjects)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .overview(.showProjects))
    }
    
    func testDeleteAccount() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.deleteAccount)
        await vm.awaitAllTasks()
        
        // then
        XCTAssert(vm.state.alertData != nil)
    }
    
    func testChangeAlertData() async {
        // given
        let vm = createViewModel()
        let alertData = AlertData(title: .randomString())
        
        // when
        vm.onIntent(.changeAlertData(to: alertData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.alertData, alertData)
    }
}
