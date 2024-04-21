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
final class ProjectDetailViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProjectDetailFlow>(
        navigationController: UINavigationController()
    )
    
    private let addAndAssignProjectUseCaseMock = AddAndAssignProjectUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    private let getProjectPreviewUseCaseMock = GetProjectPreviewUseCaseMock(
        executeReturnValue: ResultSuccess(data: ProjectPreview.stub())
    )
    private let updateProjectUseCaseMock = UpdateProjectUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    private let removeProjectUseCaseMock = RemoveProjectUseCaseMock(
        executeReturnValue: ResultSuccess(data: KotlinUnit())
    )
    
    private func createViewModel(
        editingClientId: String?,
        editingProjectId: String?
    ) -> ProjectDetailViewModel {
        Container.shared.addAndAssignProjectUseCase.register { self.addAndAssignProjectUseCaseMock }
        Container.shared.getProjectPreviewUseCase.register { self.getProjectPreviewUseCaseMock }
        Container.shared.updateProjectUseCase.register { self.updateProjectUseCaseMock }
        Container.shared.removeProjectUseCase.register { self.removeProjectUseCaseMock }
        
        return ProjectDetailViewModel(
            editingClientId: editingClientId,
            editingProjectId: editingProjectId,
            flowController: flowController
        )
    }
    
    // MARK: - Tests
    
    func testChangeName() async {
        // given
        let project = ProjectPreview.stub()
        let vm = createViewModel(
            editingClientId: project.client.id,
            editingProjectId: project.id
        )
        let newName = String.randomString()
        
        // when
        getProjectPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: project)
        vm.onAppear()
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, project.name)
        
        // when
        vm.onIntent(.changeName(to: newName))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, newName)
    }
    
    func testSelectClient() async {
        // given
        let vm = createViewModel(
            editingClientId: nil,
            editingProjectId: nil
        )
        
        // when
        vm.onIntent(.selectClient)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.handleFlowValue,
            .showClientSelection(
                selectedClientId: nil,
                delegate: nil
            )
        )
    }
    
    func testChangeProjectType() async {
        // given
        let vm = createViewModel(
            editingClientId: nil,
            editingProjectId: nil
        )
        let projectType = ProjectType.allCases.randomElement()!
        
        // when
        vm.onIntent(.changeProjectType(to: projectType))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.projectType, projectType)
    }
    
    func testRemove() async {
        // given
        let vm = createViewModel(
            editingClientId: .randomString(),
            editingProjectId: .randomString()
        )
        
        // when
        vm.onIntent(.remove)
        await vm.awaitAllTasks()
        
        // then
        XCTAssert(vm.state.alertData != nil)
    }
    
    func testCancel() async {
        // given
        let vm = createViewModel(
            editingClientId: nil,
            editingProjectId: nil
        )
        
        // when
        vm.onIntent(.cancel)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .dismiss)
    }
    
    func testSave() async {
        // given
        let project = ProjectPreview.stub()
        let vm = createViewModel(
            editingClientId: project.client.id,
            editingProjectId: project.id
        )
        
        // when
        getProjectPreviewUseCaseMock.executeReturnValue = ResultSuccess(data: project)
        vm.onAppear()
        await vm.awaitAllTasks()
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.handleFlowValue, .dismiss)
    }
    
    func testChangeAlertData() async {
        // given
        let vm = createViewModel(
            editingClientId: nil,
            editingProjectId: nil
        )
        let alertData = AlertData(title: .randomString())
        
        // when
        vm.onIntent(.changeAlertData(to: alertData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.alertData, alertData)
    }
}
