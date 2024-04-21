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
final class ClientDetailViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProfileFlow>(
        navigationController: UINavigationController()
    )
    
    private let addAndAssignClientUseCaseMock = AddAndAssignClientUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    private let getClientUseCaseMock = GetClientUseCaseMock(
        executeReturnValue: ResultSuccess(data: Client.stub())
    )
    private let updateClientUseCaseMock = UpdateClientUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    private let removeClientUseCaseMock = RemoveClientUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    
    private func createViewModel(
        editingClientId: String?
    ) -> ClientDetailViewModel {
        Container.shared.addAndAssignClientUseCase.register { self.addAndAssignClientUseCaseMock }
        Container.shared.getClientUseCase.register { self.getClientUseCaseMock }
        Container.shared.updateClientUseCase.register { self.updateClientUseCaseMock }
        Container.shared.removeClientUseCase.register { self.removeClientUseCaseMock }
        
        return ClientDetailViewModel(
            editingClientId: editingClientId,
            flowController: flowController
        )
    }
    
    // MARK: - Tests
    
    func testChangeName() async {
        // given
        let client = Client.stub()
        let vm = createViewModel(editingClientId: client.id)
        let newName = String.randomString()
        
        // when
        getClientUseCaseMock.executeReturnValue = ResultSuccess(data: client)
        vm.onAppear()
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, client.name)
        
        // when
        vm.onIntent(.changeName(to: newName))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, newName)
    }
    
    func testRemove() async {
        // given
        let vm = createViewModel(editingClientId: .randomString())
        
        // when
        vm.onIntent(.remove)
        await vm.awaitAllTasks()
        
        // then
        XCTAssert(vm.state.alertData != nil)
    }
    
    func testCancel() async {
        // given
        let vm = createViewModel(editingClientId: nil)
        
        // when
        vm.onIntent(.cancel)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .clients(.dismissModal))
    }
    
    func testSave() async {
        // given
        let vm = createViewModel(editingClientId: nil)
        let name = String.randomString(length: 10)
        
        // when
        vm.onIntent(.changeName(to: name))
        await vm.awaitAllTasks()
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .clients(.dismissModal))
    }
    
    func testChangeAlertData() async {
        // given
        let vm = createViewModel(editingClientId: nil)
        let alertData = AlertData(title: .randomString())
        
        // when
        vm.onIntent(.changeAlertData(to: alertData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.alertData, alertData)
    }
}
