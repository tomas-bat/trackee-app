//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain
import SharedDomainMocks

final class ProjectsViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getProjectsUseCase) private var getProjectsUseCase
    
    // MARK: - Stored properties
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: state.projects.isLoading)
        })
    }
    
    // MARK: - State
    
    struct State {
        var projects: ViewData<[ProjectPreview]> = .loading(mock: .stub)
        var searchText = ""
    }
    
    @Published private(set) var state = State()
    
    // MARK: - Intent
    
    enum Intent {
        case updateSearchText(to: String)
        case retry
        case showProjectDetail(clientId: String, projectId: String)
        case addProject
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .updateSearchText(text): state.searchText = text
            case .retry: await fetchData(showLoading: true)
            case let .showProjectDetail(clientId, projectId): showProjectDetail(clientId: clientId, projectId: projectId)
            case .addProject: addProject()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = false) async {
        if showLoading {
            state.projects = .loading(mock: .stub)
        }
        
        do {
            let projects: [ProjectPreview] = try await getProjectsUseCase.execute()
            
            if projects.isEmpty {
                state.projects = .empty
            } else {
                state.projects = .data(projects)
            }
        } catch {
            state.projects = .error(error)
        }
    }
    
    private func showProjectDetail(clientId: String, projectId: String) {
        flowController?.handleFlow(
            ProfileFlow.projects(
                .showDetail(
                    clientId: clientId,
                    projectId: projectId,
                    delegate: self
                )
            )
        )
    }
    
    private func addProject() {
        flowController?.handleFlow(ProfileFlow.projects(.showNewProject(delegate: self)))
    }
}

// MARK: - ClientDetailViewModelDelegate

extension ProjectsViewModel: ProjectDetailViewModelDelegate {
    func refreshProjects() async {
        await fetchData()
    }
}
