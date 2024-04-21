//
//  Created by Tomáš Batěk on 20.04.2024
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
final class ProjectSelectionViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<TimerFlow>(
        navigationController: UINavigationController()
    )
    
    private let getProjectsUseCaseMock = GetProjectsUseCaseMock(
        executeReturnValue: ResultSuccess(data: [ProjectPreview].stub as NSArray)
    )
    
    private func createViewModel() -> ProjectSelectionViewModel {
        Container.shared.getProjectsUseCase.register { self.getProjectsUseCaseMock }
        
        return ProjectSelectionViewModel(flowController: flowController)
    }
    // MARK: - Tests
    
    func testUpdateSearchText() async {
        // given
        let vm = createViewModel()
        let text = String.randomString()
        let projects = [ProjectPreview].stub
        let filteredProjects = projects.filter { project in
            let expr = text
                .filter { !$0.isWhitespace }
                .lowercased()
            
            return project.name
                .filter { !$0.isWhitespace }
                .lowercased()
                .contains(expr)
            || project.client.name
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
        if filteredProjects.isEmpty {
            XCTAssertEqual(vm.state.viewData, .empty(.search))
        } else {
            XCTAssertEqual(vm.state.viewData, .data(filteredProjects))
        }
    }
    
    func testRetry() async {
        // given
        let vm = createViewModel()
        let projects = [ProjectPreview].stub
        
        // when
        getProjectsUseCaseMock.executeReturnValue = ResultSuccess(data: projects as NSArray)
        vm.onAppear()
        await vm.awaitAllTasks()
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.viewData, .data(projects))
    }
    
    func testSelectProject() async {
        // given
        let vm = createViewModel()
        let id = String.randomString()
        
        // when
        vm.onIntent(.selectProject(id: id))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.selectedProjectId, id)
    }
    
    func testSave() async {
        // given
        let vm = createViewModel()
        let projects = [ProjectPreview].stub
        let id = projects.first!.id
        
        // when
        getProjectsUseCaseMock.executeReturnValue = ResultSuccess(data: projects as NSArray)
        vm.onAppear()
        await vm.awaitAllTasks()
        vm.onIntent(.selectProject(id: id))
        await vm.awaitAllTasks()
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .projectSelection(.dismiss))
    }
    
    func testDismiss() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.dismiss)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .projectSelection(.dismiss))
    }
}
