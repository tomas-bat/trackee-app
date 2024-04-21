//
//  Created by Tomáš Batěk on 21.04.2024
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
final class IntegrationDetailViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<IntegrationsFlow>(
        navigationController: UINavigationController()
    )
    
    private let getIntegrationUseCaseMock = GetIntegrationUseCaseMock(executeReturnValue: ResultSuccess(data: Integration.stub()))
    private let updateIntegrationUseCaseMock = UpdateIntegrationUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
    private let addIntegrationUseCaseMock = AddIntegrationUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
    private let deleteIntegrationUseCaseMock = DeleteIntegrationUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
    
    private func createViewModel(
        type: IntegrationDetailViewModel.`Type`
    ) -> IntegrationDetailViewModel {
        Container.shared.getIntegrationUseCase.register { self.getIntegrationUseCaseMock }
        Container.shared.updateIntegrationUseCase.register { self.updateIntegrationUseCaseMock }
        Container.shared.addIntegrationUseCase.register { self.addIntegrationUseCaseMock }
        Container.shared.deleteIntegrationUseCase.register { self.deleteIntegrationUseCaseMock }
        
        return IntegrationDetailViewModel(
            type: type,
            flowController: flowController
        )
    }
    
    // MARK: - Tests
    
    func testChangeLabel() async {
        // given
        let type: IntegrationDetailViewModel.`Type` = .new(integrationType: .csv)
        let vm = createViewModel(type: type)
        let newLabel = String.randomString()
        
        // when
        vm.onIntent(.changeLabel(to: newLabel))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.label, newLabel)
    }
    
    func testRetrySuccess() async {
        // given
        let id = String.randomString()
        let type: IntegrationDetailViewModel.`Type` = .edit(integrationId: id)
        let vm = createViewModel(type: type)
        let integration = Integration.stub(id: id)
        
        // when
        getIntegrationUseCaseMock.executeReturnValue = ResultSuccess(data: integration)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.integrationType, .data(integration.type))
        XCTAssertEqual(vm.state.apiKey, integration.apiKey)
        XCTAssertEqual(vm.state.label, integration.label)
    }
    
    func testRetryError() async {
        // given
        let id = String.randomString()
        let type: IntegrationDetailViewModel.`Type` = .edit(integrationId: id)
        let vm = createViewModel(type: type)
        let error = ErrorResult(message: .randomString())
        
        // when
        getIntegrationUseCaseMock.executeReturnValue = ResultError(error: error)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.integrationType, .error(error.asError))
    }
    
    func testOnExportData() async {
        // given
        let id = String.randomString()
        let integration = Integration(
            id: id,
            label: .randomString(),
            type: .clockify,
            apiKey: .randomString()
        )
        let vm = createViewModel(type: .edit(integrationId: id))
        
        // when
        getIntegrationUseCaseMock.executeReturnValue = ResultSuccess(data: integration)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        vm.onIntent(.onExportData)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .detail(.showExport(integrationType: integration.type)))
    }
    
    func testSaveSuccess() async {
        // given
        let type: IntegrationDetailViewModel.`Type` = .new(integrationType: .csv)
        let vm = createViewModel(type: type)
        let updatedIntegration = Integration.stub()
        let label = String.randomString(length: 10)
        
        // when
        updateIntegrationUseCaseMock.executeReturnValue = ResultSuccess(data: updatedIntegration)
        vm.onIntent(.changeLabel(to: label))
        await vm.awaitAllTasks()
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .detail(.pop))
    }
    
    func testChangeApiKey() async {
        // given
        let type: IntegrationDetailViewModel.`Type` = .new(integrationType: .clockify)
        let vm = createViewModel(type: type)
        let key = String.randomString()
        
        // when
        vm.onIntent(.changeApiKey(to: key))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.apiKey, key)
    }
    
    func testRemoveSuccess() async {
        // given
        let type: IntegrationDetailViewModel.`Type` = .edit(integrationId: .randomString())
        let vm = createViewModel(type: type)
        let label = String.randomString(length: 10)
        
        // when
        vm.onIntent(.changeLabel(to: label))
        await vm.awaitAllTasks()
        vm.onIntent(.remove)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .detail(.pop))
    }
}

