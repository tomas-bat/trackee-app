//
//  Created by Tomáš Batěk on 19.04.2024
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

protocol IntegrationDetailViewModelDelegate: AnyObject {
    func didUpdateIntegration() async
    func didDeleteIntegration(named: String)
}

final class IntegrationDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    enum `Type` {
        case new(integrationType: IntegrationType)
        case edit(integrationId: String)
        
        var isEdit: Bool {
            switch self {
            case .edit: true
            default: false
            }
        }
    }
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getIntegrationUseCase) private var getIntegrationUseCase
    @Injected(\.updateIntegrationUseCase) private var updateIntegrationUseCase
    @Injected(\.addIntegrationUseCase) private var addIntegrationUseCase
    @Injected(\.deleteIntegrationUseCase) private var deleteIntegrationUseCase
    @Injected(\.getProjectsUseCase) private var getProjectsUseCase
    
    // MARK: - Stored properties
    
    weak var delegate: IntegrationDetailViewModelDelegate?
    
    private let type: `Type`
    
    private var hasLoadedData = false
    
    // MARK: - Init
    
    init(
        type: `Type`,
        flowController: FlowController? = nil
    ) {
        self.type = type
        self.flowController = flowController
        super.init()
        
        switch type {
        case let .new(integrationType): 
            state.integrationType = .data(integrationType)
            state.allowRemove = false
        case .edit:
            state.allowRemove = true
            state.allowExport = true
        }
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        if !hasLoadedData {
            executeTask(Task {
                await fetchData(showLoading: type.isEdit && !state.integrationType.hasData)
                hasLoadedData = true
            })
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var integrationType: ViewData<IntegrationType> = .loading(mock: .csv)
        var label = ""
        var apiKey: String?
        var selectedProjects: [IdentifiableProject] = []
        var autoExport = false
        var saveLoading = false
        var removeLoading = false
        var allowRemove = false
        var allowExport = false
        var selectedProjectsLoading = false
        var workspaceName: String?
        var alertData: AlertData?
    }
    
    // MARK: - Intent
    
    enum Intent {
        case changeLabel(to: String)
        case retry
        case onExportData
        case save
        case changeApiKey(to: String)
        case remove
        case changeAutoExport(to: Bool)
        case changeWorkspaceName(to: String)
        case showInfoAlert(with: String)
        case changeAlertData(to: AlertData?)
        case showSelectedProjects
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeLabel(label): state.label = label
            case .retry: await fetchData(showLoading: true)
            case .onExportData: onExportData()
            case .save: await handleErrors { try await save() }
            case let .changeApiKey(key): state.apiKey = key.isEmpty ? nil : key
            case .remove: await remove()
            case let .changeAutoExport(value): state.autoExport = value
            case let .changeWorkspaceName(name): state.workspaceName = name.isEmpty ? nil : name
            case let .showInfoAlert(info): state.alertData = .init(title: info)
            case let .changeAlertData(data): state.alertData = data
            case .showSelectedProjects: showSelectedProjects()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool) async {
        switch type {
        case let .edit(integrationId):
            do {
                let params = GetIntegrationUseCaseParams(integrationId: integrationId)
                let integration: Integration = try await getIntegrationUseCase.execute(params: params)
                
                switch onEnum(of: integration) {
                case .csv: ()
                case let .clockify(clockify):
                    state.apiKey = clockify.apiKey
                    state.workspaceName = clockify.workspaceName
                    state.autoExport = clockify.autoExport
                }
                
                state.integrationType = .data(integration.type)
                state.label = integration.label
                state.selectedProjects = integration.selectedProjects
            } catch {
                state.integrationType = .error(error)
            }
        case .new:
            // Automatically select all projects on creation
            state.selectedProjectsLoading = true
            defer { state.selectedProjectsLoading = false }
            await handleErrors {
                try await Task.sleep(for: .seconds(3))
                let allProjects: [ProjectPreview] = try await getProjectsUseCase.execute()
                state.selectedProjects = allProjects.map { $0.asIdentifiableProject }
            }
        }
    }
    
    private func save() async throws {
        guard state.label.count > 1 else {
            throw IntegrationError.nameTooShort
        }
        
        state.saveLoading = true
        defer { state.saveLoading = false }
        
        switch type {
        case let .edit(integrationId):
            guard let type = state.integrationType.data else { return }
            
            let integration: Integration = switch type {
            case .csv:
                Integration.Csv(
                    id: integrationId,
                    label: state.label,
                    selectedProjects: state.selectedProjects
                )
            case .clockify:
                Integration.Clockify(
                    id: integrationId,
                    label: state.label,
                    selectedProjects: state.selectedProjects,
                    apiKey: state.apiKey,
                    workspaceName: state.workspaceName,
                    autoExport: state.autoExport
                )
            }
            let params = UpdateIntegrationUseCaseParams(integration: integration)
            
            await handleErrors {
                try await updateIntegrationUseCase.execute(params: params)
                await delegate?.didUpdateIntegration()
                snackState.showSnackSync(.info(message: L10n.integration_detail_saved_label))
            }
        case let .new(integrationType):
            let integration = switch integrationType {
            case .csv:
                NewIntegration.Csv(
                    label: state.label,
                    selectedProjects: state.selectedProjects
                )
            case .clockify:
                NewIntegration.Clockify(
                    label: state.label,
                    selectedProjects: state.selectedProjects,
                    apiKey: state.apiKey,
                    workspaceName: state.workspaceName,
                    autoExport: state.autoExport
                )
            }
            let params = AddIntegrationUseCaseParams(integration: integration)
            
            await handleErrors {
                try await addIntegrationUseCase.execute(params: params)
                await delegate?.didUpdateIntegration()
                snackState.showSnackSync(.info(message: L10n.integration_detail_saved_label))
            }
        }
    }
    
    private func handleErrors(block: () async throws -> Void) async {
        do {
            try await block()
        } catch {
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func pop() {
        flowController?.handleFlow(IntegrationsFlow.detail(.pop))
    }
    
    private func remove() async {
        switch type {
        case let .edit(integrationId):
            state.removeLoading = true
            defer { state.removeLoading = false }
            
            do {
                let params = DeleteIntegrationUseCaseParams(integrationId: integrationId)
                try await deleteIntegrationUseCase.execute(params: params)
                
                await delegate?.didUpdateIntegration()
                delegate?.didDeleteIntegration(named: state.label)
                pop()
            } catch {
                snackState.currentData?.dismiss()
                snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
            }
        default: return
        }
    }
    
    private func onExportData() {
        guard let type = state.integrationType.data else { return }
        
        switch self.type {
        case let .edit(integrationId):
            flowController?.handleFlow(
                IntegrationsFlow.detail(
                    .showExport(
                        integrationId: integrationId,
                        integrationType: type,
                        apiKey: state.apiKey,
                        workspaceName: state.workspaceName
                    )
                )
            )
        default: return
        }
        
    }
    
    private func showSelectedProjects() {
        flowController?.handleFlow(IntegrationsFlow.detail(.showSelectedProjects(
            with: state.selectedProjects,
            delegate: self
        )))
    }
}

extension IntegrationDetailViewModel: SelectedProjectsViewModelDelegate {
    func didConfirmSelection(with projects: [IdentifiableProject]) {
        state.selectedProjects = projects
    }
}
