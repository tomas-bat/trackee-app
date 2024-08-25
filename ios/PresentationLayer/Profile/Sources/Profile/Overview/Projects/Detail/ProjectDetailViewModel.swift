//
//  Created by Tomáš Batěk on 03.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import KMPSharedDomain

protocol ProjectDetailViewModelDelegate: AnyObject {
    func refreshProjects() async
    func didRemoveProject(named: String)
}

final class ProjectDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    struct ValidatedData {
        let clientId: String
    }
    
    // MARK: - Dependencies
    
    @Injected(\.addAndAssignProjectUseCase) private var addAndAssignProjectUseCase
    @Injected(\.getProjectPreviewUseCase) private var getProjectPreviewUseCase
    @Injected(\.updateProjectUseCase) private var updateProjectUseCase
    @Injected(\.removeProjectUseCase) private var removeProjectUseCase
    
    private weak var flowController: FlowController?
    
    // MARK: - Stored properties
    
    weak var delegate: ProjectDetailViewModelDelegate?
    
    private let editingClientId: String?
    private let editingProjectId: String?
    
    private var didFetch = false
    
    // MARK: - Init
    
    init(
        editingClientId: String? = nil,
        editingProjectId: String? = nil,
        flowController: FlowController? = nil
    ) {
        self.editingClientId = editingClientId
        self.editingProjectId = editingProjectId
        self.flowController = flowController
        super.init()
        
        state.isCreating = editingProjectId == nil && editingClientId == nil
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        guard !didFetch else { return }
        executeTask(Task {
            await fetchData(showLoading: !didFetch)
        })
    }
    
    // MARK: - State
    
    struct State {
        var isCreating = false
        var name = ""
        var client: Client?
        var projectType: ProjectType?
        var projectColor: ProjectColor?
        var isLoading = true
        var saveLoading = false
        var removeLoading = false
        var alertData: AlertData?
    }
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Intent
    
    enum Intent {
        case changeName(to: String)
        case selectClient
        case changeProjectType(to: ProjectType?)
        case changeProjectColor(to: ProjectColor?)
        case remove
        case cancel
        case save
        case changeAlertData(to: AlertData?)
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeName(name): state.name = name
            case .selectClient: selectClient()
            case let .changeProjectType(type): state.projectType = type
            case let .changeProjectColor(color): state.projectColor = color
            case .remove: showRemoveAlert()
            case .cancel: dismiss()
            case .save: await save()
            case let .changeAlertData(alertData): state.alertData = alertData
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool) async {
        if showLoading {
            state.isLoading = true
        }
        defer { state.isLoading = false }
        
        await execute {
            if let editingProjectId, let editingClientId {
                let params = GetProjectPreviewUseCaseParams(
                    clientId: editingClientId,
                    projectId: editingProjectId
                )
                let project: ProjectPreview = try await getProjectPreviewUseCase.execute(params: params)
                state.name = project.name
                state.client = project.client
                state.projectType = project.type
                state.projectColor = project.color
            }
                
            didFetch = true
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func selectClient() {
        flowController?.handleFlow(ProjectDetailFlow.showClientSelection(
            selectedClientId: state.client?.id,
            delegate: self
        ))
    }
    
    private func dismiss() {
        flowController?.handleFlow(ProjectDetailFlow.dismiss)
    }
    
    private func save() async {
        state.saveLoading = true
        defer { state.saveLoading = false }
        
        await execute {
            let validatedData = try validate()
            
            if let editingProjectId, let editingClientId {
                let project = Project(
                    id: editingProjectId,
                    clientId: validatedData.clientId,
                    type: state.projectType,
                    name: state.name,
                    color: state.projectColor
                )
                let params = UpdateProjectUseCaseParams(
                    originalClientId: editingClientId,
                    project: project
                )
                try await updateProjectUseCase.execute(params: params)
            } else {
                let project = NewProject(
                    clientId: validatedData.clientId,
                    type: state.projectType,
                    name: state.name,
                    color: state.projectColor
                )
                let params = AddAndAssignProjectUseCaseParams(project: project)
                try await addAndAssignProjectUseCase.execute(params: params)
            }
            
            await delegate?.refreshProjects()
            dismiss()
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func validate() throws -> ValidatedData {
        guard state.name.count >= 2 else {
            throw ProfileError.validation(.nameTooShort)
        }
        guard let clientId = state.client?.id else {
            throw ProfileError.validation(.missingClient)
        }
        
        return ValidatedData(
            clientId: clientId
        )
    }
    
    private func showRemoveAlert() {
        state.alertData = AlertData(
            title: L10n.project_detail_remove_alert_title,
            message: L10n.project_detail_remove_alert_text,
            primaryAction: .init(
                title: L10n.yes,
                style: .destruction
            ) { [weak self] in
                self?.executeTask(Task {
                    await self?.remove()
                })
            },
            secondaryAction: .init(title: L10n.cancel)
        )
    }
    
    private func remove() async {
        guard let editingProjectId, let editingClientId else { return }
        
        state.removeLoading = true
        defer { state.removeLoading = false }
        
        await execute {
            let params = RemoveProjectUseCaseParams(
                clientId: editingClientId,
                projectId: editingProjectId
            )
            try await removeProjectUseCase.execute(params: params)
            
            await delegate?.refreshProjects()
            delegate?.didRemoveProject(named: state.name)
            dismiss()
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
}

// MARK: - ClientSelectionViewModelDelegate

extension ProjectDetailViewModel: ClientSelectionViewModelDelegate {
    func didSelectClient(_ client: Client) {
        state.client = client
    }
}
