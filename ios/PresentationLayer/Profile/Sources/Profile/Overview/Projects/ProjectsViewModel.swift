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
    
    // MARK: - Constants
    
    private let messageDelay: TimeInterval = 0.5
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getProjectsUseCase) private var getProjectsUseCase
    
    // MARK: - Stored properties
    
    private var projects: [ProjectPreview] = []
    
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
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
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
            case let .updateSearchText(text): updateSearchText(to: text)
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
        
        state.searchText = ""
        
        await execute {
            projects = try await getProjectsUseCase.execute()
            filterProjects()
        } onError: { error in
            state.projects = .error(error)
        }
    }
    
    private func updateSearchText(to text: String) {
        state.searchText = text
        filterProjects()
    }
    
    private func filterProjects() {
        if projects.isEmpty {
            state.projects = .empty(.noData)
            return
        }
        if state.searchText.isEmpty {
            state.projects = .data(projects)
            return
        }
        let filtered = projects.filter { project in
            let expr = state.searchText
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
        if filtered.isEmpty {
            state.projects = .empty(.search)
        } else {
            state.projects = .data(filtered)
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
    
    func didRemoveProject(named projectName: String) {
        Task.delayed(byTimeInterval: messageDelay) { [weak self] in
            self?.snackState.currentData?.dismiss()
            self?.snackState.showSnackSync(.info(
                message: "\(L10n.project_removed_snack_title_part_one) \(projectName) \(L10n.project_removed_snack_title_part_two)"
            ))
        }
    }
}
