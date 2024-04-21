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
final class ClientsViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProfileFlow>(
        navigationController: UINavigationController()
    )
    
    private let getClientsUseCaseMock = GetClientsUseCaseMock(
        executeReturnValue: ResultSuccess(data: [Client].stub as NSArray)
    )
    
    private func createViewModel() -> ClientsViewModel {
        Container.shared.getClientsUseCase.register { self.getClientsUseCaseMock }
        
        return ClientsViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    func testUpdateSearchText() async {
        // given
        let vm = createViewModel()
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
        let vm = createViewModel()
        let clients = [Client].stub
        
        // when
        getClientsUseCaseMock.executeReturnValue = ResultSuccess(data: clients as NSArray)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.clients, .data(clients))
    }
    
    func testShowClientDetail() async {
        // given
        let vm = createViewModel()
        let clientId = String.randomString()
        
        // when
        vm.onIntent(.showClientDetail(clientId: clientId))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .clients(.showDetail(clientId: clientId, delegate: nil)))
    }
    
    func testAddClient() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.addClient)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .clients(.showNewClient(delegate: nil)))
    }
}
