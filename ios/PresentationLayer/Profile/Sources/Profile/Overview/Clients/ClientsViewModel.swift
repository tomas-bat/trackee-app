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

final class ClientsViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Constants
    
    private let messageDelay: TimeInterval = 0.5
    private let maxFreeCliensCount: Int = 3
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getClientsUseCase) private var getClientsUseCase
    @Injected(\.getHasFullAccessUseCase) private var getHasFullAccessUseCase
    
    // MARK: - Stored properties
    
    private var clients: [Client] = []
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: state.clients.isLoading)
        })
    }
    
    // MARK: - State
    
    struct State {
        var clients: ViewData<[Client]> = .loading(mock: .stub)
        var searchText = ""
        var addClientLoading = false
    }
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Intent
    
    enum Intent {
        case updateSearchText(to: String)
        case retry
        case showClientDetail(clientId: String)
        case addClient
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .updateSearchText(text): updateSearchText(to: text)
            case .retry: await fetchData(showLoading: true)
            case let .showClientDetail(clientId): showClientDetail(clientId: clientId)
            case .addClient: await addClient()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = false) async {
        if showLoading {
            state.clients = .loading(mock: .stub)
        }
        
        state.searchText = ""
        
        await execute {
            clients = try await getClientsUseCase.execute()
            filterClients()
        } onError: { error in
            state.clients = .error(error)
        }
    }
    
    private func updateSearchText(to text: String) {
        state.searchText = text
        filterClients()
    }
    
    private func filterClients() {
        if clients.isEmpty {
            state.clients = .empty(.noData)
            return
        }
        if state.searchText.isEmpty {
            state.clients = .data(clients)
            return
        }
        let filtered = clients.filter { client in
            let expr = state.searchText
                .filter { !$0.isWhitespace }
                .lowercased()
            
            return client.name
                .filter { !$0.isWhitespace }
                .lowercased()
                .contains(expr)
        }
        if filtered.isEmpty {
            state.clients = .empty(.search)
        } else {
            state.clients = .data(filtered)
        }
    }
    
    private func showClientDetail(clientId: String) {
        flowController?.handleFlow(ProfileFlow.clients(.showDetail(clientId: clientId, delegate: self)))
    }
    
    private func addClient() async {
        state.addClientLoading = true
        defer { state.addClientLoading = false }
        
        await execute {
            let hasFullAccess: Bool = try await getHasFullAccessUseCase.execute()
            
            if (state.clients.data?.count ?? 0) >= maxFreeCliensCount && !hasFullAccess {
                flowController?.handleFlow(
                    ProfileFlow.showPaywall(
                        paywallViewOrigin: .clients(maxFreeCount: maxFreeCliensCount),
                        delegate: self
                    )
                )
            } else {
                flowController?.handleFlow(ProfileFlow.clients(.showNewClient(delegate: self)))
            }
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
}

// MARK: - ClientDetailViewModelDelegate

extension ClientsViewModel: ClientDetailViewModelDelegate {
    func refreshClients() async {
        await fetchData()
    }
    
    func didRemoveClient(named clientName: String) {
        Task.delayed(byTimeInterval: messageDelay) { [weak self] in
            self?.snackState.currentData?.dismiss()
            self?.snackState.showSnackSync(.info(
                message: "\(L10n.client_removed_snack_title_part_one) \(clientName) \(L10n.client_removed_snack_title_part_two)"
            ))
        }
    }
}

// MARK: - PaywallViewModelDelegate

extension ClientsViewModel: PaywallViewModelDelegate {
    func didPurchasePackage(_ package: PurchasePackage) {
        flowController?.handleFlow(ProfileFlow.clients(.dismissModal))
    }
    
    func didDismiss() {
        flowController?.handleFlow(ProfileFlow.clients(.dismissModal))
    }
}
