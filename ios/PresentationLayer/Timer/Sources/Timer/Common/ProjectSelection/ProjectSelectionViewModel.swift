//
//  Created by Tomáš Batěk on 27.03.2024
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

protocol ProjectSelectionViewModelDelegate: AnyObject {
    func didSelectProject(_: ProjectPreview)
}

final class ProjectSelectionViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getProjectsUseCase) private var getProjectsUseCase
    
    // MARK: - Stored properties
    
    weak var delegate: ProjectSelectionViewModelDelegate?
    
    private var projects: [ProjectPreview] = []
    
    // MARK: - Init
    
    init(
        selectedProjectId: String? = nil,
        isEmbedded: Bool,
        flowController: FlowController? = nil
    ) {
        self.flowController = flowController
        super.init()
        
        state.selectedProjectId = selectedProjectId
        state.isEmbedded = isEmbedded
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task { await fetchData() })
    }
    
    // MARK: - State
    
    struct State {
        var searchText: String = ""
        var viewData: ViewData<[ProjectPreview]> = .loading(mock: .stub)
        var selectedProjectId: String?
        var isEmbedded = false
    }
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Intent
    
    enum Intent {
        case updateSearchText(to: String)
        case retry
        case selectProject(id: String)
        case save
        case dismiss
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .updateSearchText(text): updateSearchText(to: text)
            case .retry: await fetchData(force: true)
            case let .selectProject(id): state.selectedProjectId = id
            case .save: save()
            case .dismiss: dismiss()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(force: Bool = false) async {
        guard force || !state.viewData.hasData else { return }
        
        state.searchText = ""
                
        do {
            projects = try await getProjectsUseCase.execute()
            filterProjects()
        } catch {
            state.viewData = .error(error)
        }
    }
    
    private func updateSearchText(to text: String) {
        state.searchText = text
        filterProjects()
    }
    
    private func save() {
        guard let project = state.viewData.data?.first(
            where: { $0.id == state.selectedProjectId }
        ) else { return }
        
        delegate?.didSelectProject(project)
        if state.isEmbedded {
            flowController?.handleFlow(TimerFlow.projectSelection(.pop))
        } else {
            dismiss()
        }
    }
    
    private func dismiss() {
        flowController?.handleFlow(TimerFlow.projectSelection(.dismiss))
    }
    
    private func filterProjects() {
        if projects.isEmpty {
            state.viewData = .empty(.noData)
            return
        }
        if state.searchText.isEmpty {
            state.viewData = .data(projects)
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
            state.viewData = .empty(.search)
        } else {
            state.viewData = .data(filtered)
        }
    }
}
