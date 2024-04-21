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
final class IntegrationExportViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<IntegrationsFlow>(
        navigationController: UINavigationController()
    )
    
    private let exportToCsvUseCaseMock = ExportToCsvUseCaseMock(
        executeReturnValue: ResultSuccess(data: String.randomString() as NSString)
    )
    
    private func createViewModel(
        type: IntegrationType
    ) -> IntegrationExportViewModel {
        Container.shared.exportToCsvUseCase.register { self.exportToCsvUseCaseMock }
        
        return IntegrationExportViewModel(integrationType: type)
    }
    
    private var randomType = IntegrationType.allCases.randomElement()!
    
    // MARK: - Tests
    
    func testChangeFromDate() async {
        // given
        let type = randomType
        let vm = createViewModel(type: type)
        let fromDate = Date(timeIntervalSince1970: .random(in: 0...TimeInterval.greatestFiniteMagnitude))
        
        // when
        vm.onIntent(.changeFromDate(to: fromDate))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.fromDate, fromDate)
    }
    
    func testChangeToDate() async {
        // given
        let type = randomType
        let vm = createViewModel(type: type)
        let toDate = Date(timeIntervalSince1970: .random(in: 0...TimeInterval.greatestFiniteMagnitude))
        
        // when
        vm.onIntent(.changeToDate(to: toDate))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.toDate, toDate)
    }
}
