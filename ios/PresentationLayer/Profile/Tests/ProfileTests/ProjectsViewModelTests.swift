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
final class ProjectsViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProfileFlow>(
        navigationController: UINavigationController()
    )
    
    private let getProjectsUseCaseMock = GetProjectsUseCaseMock(
        executeReturnValue: ResultSuccess(data: [ProjectPreview].stub as NSArray)
    )
    
    private func createViewModel() -> ProjectsViewModel {
        Container.shared.getProjectsUseCase.register { self.getProjectsUseCaseMock }
        
        return ProjectsViewModel(flowController: flowController)
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
            XCTAssertEqual(vm.state.projects, .empty(.search))
        } else {
            XCTAssertEqual(vm.state.projects, .data(filteredProjects))
        }
    }
    
    func testRetry() async {
        // given
        let vm = createViewModel()
        let projects = [ProjectPreview].stub
        
        // when
        getProjectsUseCaseMock.executeReturnValue = ResultSuccess(data: projects as NSArray)
        vm.onIntent(.retry)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.projects, .data(projects))
    }
    
    func testShowProjectDetail() async {
        // given
        let vm = createViewModel()
        let clientId = String.randomString()
        let projectId = String.randomString()
        
        // when
        vm.onIntent(.showProjectDetail(clientId: clientId, projectId: projectId))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .projects(.showDetail(clientId: clientId, projectId: projectId, delegate: nil))
        )
    }
    
    func testAddProject() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.addProject)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .projects(.showNewProject(delegate: nil)))
    }
}
