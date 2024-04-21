//
//  Created by Tomáš Batěk on 20.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
@testable import Integrations
import Factory
import SharedDomain
import SharedDomainMocks
import UIToolkit
import XCTest
import DependencyInjection
import DependencyInjectionMocks
import Utilities

@MainActor
final class IntegrationsOverviewViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<IntegrationsFlow>(
        navigationController: UINavigationController()
    )
    
    private let getIntegrationsUseCaseMock = GetIntegrationsUseCaseMock(
        executeReturnValue: ResultSuccess(data: [Integration].stub as NSArray)
    )
    
    private func createViewModel() -> IntegrationsOverviewViewModel {
        Container.shared.getIntegrationsUseCase.register { self.getIntegrationsUseCaseMock }
        
        return IntegrationsOverviewViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    private func testRetrySuccess() async {
        // given
        let vm = createViewModel()
        let integrations = [Integration.stub()]
        
        // when
        getIntegrationsUseCaseMock.executeReturnValue = ResultSuccess(data: integrations as NSArray)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.integrations, .data(integrations))
    }
    
    private func testRetryNoData() async {
        // given
        let vm = createViewModel()
        let integrations = [Integration]()
        
        // when
        getIntegrationsUseCaseMock.executeReturnValue = ResultSuccess(data: integrations as NSArray)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.integrations, .empty(.noData))
    }
    
    private func testRetryError() async {
        // given
        let vm = createViewModel()
        let error = ErrorResult(message: .randomString())
        
        // when
        getIntegrationsUseCaseMock.executeReturnValue = ResultError(error: error)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.integrations, .error(error.asError))
    }
    
    private func testAddIntegration() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.addIntegration)
        await vm.awaitAllTasks()
        
        // then
        XCTAssert(vm.state.isShowingTypes)
    }
    
    private func testShowIntegrationDetail() async {
        // given
        let vm = createViewModel()
        let id = String.randomString()
        
        // when
        vm.onIntent(.showIntegrationDetail(id: id))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .overview(.showIntegrationDetail(integrationId: id, delegate: nil))
        )
    }
    
    private func testChangeShowingTypes() async {
        // given
        let vm = createViewModel()
        let value = Bool.random()
        
        // when
        vm.onIntent(.changeShowingTypes(to: value))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.isShowingTypes, value)
    }
}
