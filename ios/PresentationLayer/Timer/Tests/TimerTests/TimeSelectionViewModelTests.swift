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
final class TimeSelectionViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<TimerFlow>(
        navigationController: UINavigationController()
    )
    
    private func createViewModel(
        initialStart: Date?,
        initialEnd: Date?
    ) -> TimeSelectionViewModel {
        return TimeSelectionViewModel(
            initialStart: initialStart,
            initialEnd: initialEnd,
            flowController: flowController
        )
    }
    
    // MARK: - Tests
    
    func testOnStartChange() async {
        // given
        let initialStart = Date.distantPast
        let initialEnd = Date.distantFuture
        let newStart = Date.now
        let vm = createViewModel(
            initialStart: initialStart,
            initialEnd: initialEnd
        )
        
        // when
        vm.onIntent(.onStartChange(newStart))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.start, newStart)
    }
    
    func testOnEndChange() async {
        // given
        let initialStart = Date.distantPast
        let initialEnd = Date.distantFuture
        let newEnd = Date.now
        let vm = createViewModel(
            initialStart: initialStart,
            initialEnd: initialEnd
        )
        
        // when
        vm.onIntent(.onEndChange(newEnd))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.end, newEnd)
    }
    
    func testSave() async {
        // given
        let initialStart = Date.distantPast
        let initialEnd = Date.distantFuture
        let vm = createViewModel(
            initialStart: initialStart,
            initialEnd: initialEnd
        )
        
        // when
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .timeSelection(.dismiss))
    }
    
    func testDismiss() async {
        // given
        let initialStart = Date.distantPast
        let initialEnd = Date.distantFuture
        let vm = createViewModel(
            initialStart: initialStart,
            initialEnd: initialEnd
        )
        
        // when
        vm.onIntent(.dismiss)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .timeSelection(.dismiss))
    }
}
