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
    
    // MARK: - Stored properties
    
    weak var delegate: IntegrationDetailViewModelDelegate?
    
    private let type: `Type`
    
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
        }
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: type.isEdit && !state.integrationType.hasData)
        })
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var integrationType: ViewData<IntegrationType> = .loading(mock: .csv)
        var label = ""
        var apiKey: String?
        var saveLoading = false
        var removeLoading = false
        var allowRemove = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        case changeLabel(to: String)
        case retry
        case onExportData
        case save
        case changeApiKey(to: String)
        case remove
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeLabel(label): state.label = label
            case .retry: await fetchData(showLoading: true)
            case .onExportData: onExportData()
            case .save: await save()
            case let .changeApiKey(key): state.apiKey = key
            case .remove: await remove()
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
                }
                
                
                state.integrationType = .data(integration.type)
                state.label = integration.label
            } catch {
                state.integrationType = .error(error)
            }
        default: ()
        }
    }
    
    private func save() async {
        guard state.label.count > 1 else {
            handleError(IntegrationError.nameTooShort)
            return
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
                    label: state.label
                )
            case .clockify:
                Integration.Clockify(
                    id: integrationId,
                    label: state.label,
                    apiKey: state.apiKey,
                    autoExport: false
                )
            }
            let params = UpdateIntegrationUseCaseParams(integration: integration)
            
            do {
                try await updateIntegrationUseCase.execute(params: params)
                await delegate?.didUpdateIntegration()
                pop()
            } catch {
                handleError(error)
            }
        case let .new(integrationType):
            let integration = switch integrationType {
            case .csv:
                NewIntegration.Csv(label: state.label)
            case .clockify:
                NewIntegration.Clockify(
                    label: state.label,
                    apiKey: state.apiKey,
                    autoExport: false
                )
            }
            let params = AddIntegrationUseCaseParams(integration: integration)
            
            do {
                try await addIntegrationUseCase.execute(params: params)
                await delegate?.didUpdateIntegration()
                pop()
            } catch {
                handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        snackState.currentData?.dismiss()
        snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
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
        flowController?.handleFlow(IntegrationsFlow.detail(.showExport(integrationType: type)))
    }
}
