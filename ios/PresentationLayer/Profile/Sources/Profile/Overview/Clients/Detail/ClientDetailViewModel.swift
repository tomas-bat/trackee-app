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

protocol ClientDetailViewModelDelegate: AnyObject {
    func refreshClients() async
    func didRemoveClient(named: String)
}

final class ClientDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    @Injected(\.addAndAssignClientUseCase) private var addAndAssignClientUseCase
    @Injected(\.getClientUseCase) private var getClientUseCase
    @Injected(\.updateClientUseCase) private var updateClientUseCase
    @Injected(\.removeClientUseCase) private var removeClientUseCase
    
    private weak var flowController: FlowController?
    
    // MARK: - Stored properties
    
    weak var delegate: ClientDetailViewModelDelegate?
    
    private let editingClientId: String?
    
    private var didFetch = false
    
    // MARK: - Init
    
    init(
        editingClientId: String? = nil,
        flowController: FlowController? = nil
    ) {
        self.editingClientId = editingClientId
        self.flowController = flowController
        super.init()
        
        state.isCreating = editingClientId == nil
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: !didFetch)
        })
    }
    
    // MARK: - State
    
    struct State {
        var isCreating = false
        var name = ""
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
        case remove
        case cancel
        case save
        case changeAlertData(to: AlertData?)
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeName(name): state.name = name
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
            if let editingClientId {
                let params = GetClientUseCaseParams(clientId: editingClientId)
                let client: Client = try await getClientUseCase.execute(params: params)
                state.name = client.name
            }
                
            didFetch = true
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func dismiss() {
        flowController?.handleFlow(ProfileFlow.clients(.dismissModal))
    }
    
    private func save() async {
        state.saveLoading = true
        defer { state.saveLoading = false }
        
        await execute {
            try validate()
            
            if let editingClientId {
                let client = Client(
                    id: editingClientId,
                    name: state.name
                )
                let params = UpdateClientUseCaseParams(client: client)
                try await updateClientUseCase.execute(params: params)
            } else {
                let client = NewClient(name: state.name)
                let params = AddAndAssignClientUseCaseParams(client: client)
                try await addAndAssignClientUseCase.execute(params: params)
            }
            
            await delegate?.refreshClients()
            dismiss()
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func validate() throws {
        guard state.name.count >= 2 else {
            throw ProfileError.validation(.nameTooShort)
        }
    }
    
    private func showRemoveAlert() {
        state.alertData = AlertData(
            title: L10n.client_detail_remove_alert_title,
            message: L10n.client_detail_remove_alert_text,
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
        guard let editingClientId else { return }
        
        state.removeLoading = true
        defer { state.removeLoading = false }
        
        await execute {
            let params = RemoveClientUseCaseParams(clientId: editingClientId)
            try await removeClientUseCase.execute(params: params)
            
            await delegate?.refreshClients()
            delegate?.didRemoveClient(named: state.name)
            dismiss()
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
}
