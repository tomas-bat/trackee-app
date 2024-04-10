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
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getClientsUseCase) private var getClientsUseCase
    
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
    }
    
    @Published private(set) var state = State()
    
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
            case .addClient: addClient()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = false) async {
        if showLoading {
            state.clients = .loading(mock: .stub)
        }
        
        state.searchText = ""
        
        do {
            clients = try await getClientsUseCase.execute()
            filterClients()
        } catch {
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
    
    private func addClient() {
        flowController?.handleFlow(ProfileFlow.clients(.showNewClient(delegate: self)))
    }
}

// MARK: - ClientDetailViewModelDelegate

extension ClientsViewModel: ClientDetailViewModelDelegate {
    func refreshClients() async {
        await fetchData()
    }
}
