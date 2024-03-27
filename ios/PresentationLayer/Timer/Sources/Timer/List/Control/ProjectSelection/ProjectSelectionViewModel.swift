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

final class ProjectSelectionViewModel: BaseViewModel, ViewModel, ObservableObject {
    
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
        
        executeTask(Task { await fetchData() })
    }
    
    // MARK: - State
    
    struct State {
        var searchText: String = ""
        var viewData: ViewData<[ProjectPreview]> = .loading(mock: .stub)
        var selectedProjectId: String?
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
            case let .updateSearchText(text): state.searchText = text
            case .retry: await fetchData(force: true)
            case let .selectProject(id): state.selectedProjectId = id
            case .save: () // TODO: save
            case .dismiss: flowController?.handleFlow(TimerFlow.projectSelection(.dismiss))
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(force: Bool = false) async {
        guard force || !state.viewData.hasData else { return }
                
        do {
            let projects: [ProjectPreview] = try await getProjectsUseCase.execute()
            
            state.viewData = .data(projects)
        } catch {
            state.viewData = .error(error)
        }
    }
}
