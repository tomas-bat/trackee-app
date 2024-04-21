//
//  Created by Tomáš Batěk on 21.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
@testable import Timer
import Factory
import SharedDomain
import SharedDomainMocks
import UIToolkit
import XCTest
import DependencyInjection
import DependencyInjectionMocks
import Utilities

@MainActor
final class StartTimeSelectionViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<TimerFlow>(
        navigationController: UINavigationController()
    )
    
    private func createViewModel(
        initialStart: Date?
    ) -> StartTimeSelectionViewModel {
        return StartTimeSelectionViewModel(
            initialStart: initialStart,
            flowController: flowController
        )
    }
    // MARK: - Tests
 
    func testOnStartChange() async {
        // given
        let initialStart = Date.distantPast
        let newStart = Date.now
        let vm = createViewModel(initialStart: initialStart)
        
        // when
        vm.onIntent(.onStartChange(newStart))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.start, newStart)
    }
    
    func testSave() async {
        // given
        let initialStart = Date.distantPast
        let vm = createViewModel(initialStart: initialStart)
        
        // when
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .startTimeSelection(.dismiss))
    }
    
    func testDismiss() async {
        // given
        let initialStart = Date.distantPast
        let vm = createViewModel(initialStart: initialStart)
        
        // when
        vm.onIntent(.dismiss)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .startTimeSelection(.dismiss))
    }
}
