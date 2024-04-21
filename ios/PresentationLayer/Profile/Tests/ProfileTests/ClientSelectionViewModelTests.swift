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
final class ClientSelectionViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProjectDetailFlow>(
        navigationController: UINavigationController()
    )
    
    private let getClientsUseCaseMock = GetClientsUseCaseMock(
        executeReturnValue: ResultSuccess(data: [Client].stub as NSArray)
    )
    
    private func createViewModel(
        selectedClientId: String?
    ) -> ClientSelectionViewModel {
        Container.shared.getClientsUseCase.register { self.getClientsUseCaseMock }
        
        return ClientSelectionViewModel(flowController: flowController)
    }
    // MARK: - Tests
    
    func testUpdateSearchText() async {
        // given
        let vm = createViewModel(selectedClientId: nil)
        let text = String.randomString()
        let clients = [Client].stub
        let filteredClients = clients.filter { client in
            let expr = text
                .filter { !$0.isWhitespace }
                .lowercased()
            
            return client.name
                .filter { !$0.isWhitespace }
                .lowercased()
                .contains(expr)
        }
        
        // when
        vm.onAppear()
        await vm.awaitAllTasks()
        vm.onIntent(.updateSearchText(to: text))
        await vm.awaitAllTasks()
        
        // then
        if filteredClients.isEmpty {
            XCTAssertEqual(vm.state.clients, .empty(.search))
        } else {
            XCTAssertEqual(vm.state.clients, .data(filteredClients))
        }
    }
    
    func testRetry() async {
        // given
        let vm = createViewModel(selectedClientId: nil)
        let clients = [Client].stub
        
        // when
        getClientsUseCaseMock.executeReturnValue = ResultSuccess(data: clients as NSArray)
        vm.onAppear()
        await vm.awaitAllTasks()
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.clients, .data(clients))
    }
    
    func testSelectClient() async {
        // given
        let vm = createViewModel(selectedClientId: nil)
        let id = String.randomString()
        
        // when
        vm.onIntent(.selectClient(id: id))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.selectedClientId, id)
    }
    
    func testSave() async {
        // given
        let vm = createViewModel(selectedClientId: nil)
        let clients = [Client].stub
        let id = clients.first!.id
        
        // when
        getClientsUseCaseMock.executeReturnValue = ResultSuccess(data: clients as NSArray)
        vm.onAppear()
        await vm.awaitAllTasks()
        vm.onIntent(.selectClient(id: id))
        await vm.awaitAllTasks()
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .pop)
    }
}
