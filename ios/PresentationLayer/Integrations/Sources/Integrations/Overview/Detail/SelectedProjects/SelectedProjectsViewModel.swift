//
//  Created by Tomáš Batěk on 11.05.2024
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

protocol SelectedProjectsViewModelDelegate: AnyObject {
    func didConfirmSelection(with: [IdentifiableProject])
}

final class SelectedProjectsViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependnencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getProjectsUseCase) private var getProjectsUseCase
    
    // MARK: - Stored properties
    
    private let selectedProjects: [IdentifiableProject]
    
    private var projects: [ProjectPreview] = []
    
    weak var delegate: SelectedProjectsViewModelDelegate?
    
    // MARK: - Init
    
    init(
        selectedProjects: [IdentifiableProject],
        flowController: FlowController? = nil
    ) {
        self.selectedProjects = selectedProjects
        self.flowController = flowController
        super.init()
        
        state.selectedProjects = selectedProjects
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: state.projects.isLoading)
        })
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var projects: ViewData<[ProjectPreview]> = .loading(mock: .stub)
        var selectedProjects: [IdentifiableProject] = []
        var searchText = ""
    }
    
    // MARK: - Intent
    
    enum Intent {
        case updateSearchText(to: String)
        case retry
        case selectProject(clientId: String, projectId: String)
        case save
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .updateSearchText(text): updateSearchText(to: text)
            case .retry: await fetchData(showLoading: true)
            case let .selectProject(clientId, projectId): selectProject(clientId: clientId, projectId: projectId)
            case .save: save()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = false) async {
        if showLoading {
            state.projects = .loading(mock: .stub)
        }
        
        state.searchText = ""
        
        do {
            projects = try await getProjectsUseCase.execute()
            filterProjects()
        } catch {
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
    
    private func save() {
        delegate?.didConfirmSelection(with: state.selectedProjects)
        flowController?.handleFlow(IntegrationsFlow.detail(.pop))
    }
    
    private func selectProject(clientId: String, projectId: String) {
        let project = IdentifiableProject(
            projectId: projectId,
            clientId: clientId
        )
        
        if state.selectedProjects.contains(project) {
            state.selectedProjects.removeAll(where: { $0 == project })
        } else {
            state.selectedProjects.append(project)
        }
    }
}
