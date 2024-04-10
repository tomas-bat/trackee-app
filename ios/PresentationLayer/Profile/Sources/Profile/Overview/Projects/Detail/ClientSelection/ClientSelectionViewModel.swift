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

protocol ClientSelectionViewModelDelegate: AnyObject {
    func didSelectClient(_: Client)
}

final class ClientSelectionViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getClientsUseCase) private var getClientsUseCase
    
    // MARK: - Stored properties
    
    weak var delegate: ClientSelectionViewModelDelegate?
    
    private var clients: [Client] = []
    
    // MARK: - Init
    
    init(
        selectedClientId: String? = nil,
        flowController: FlowController? = nil
    ) {
        self.flowController = flowController
        super.init()
        
        state.selectedClientId = selectedClientId
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
        var selectedClientId: String?
        var searchText = ""
    }
    
    @Published private(set) var state = State()
    
    // MARK: - Intent
    
    enum Intent {
        case updateSearchText(to: String)
        case retry
        case selectClient(id: String)
        case save
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .updateSearchText(text): updateSearchText(to: text)
            case .retry: await fetchData(showLoading: true)
            case let .selectClient(id): state.selectedClientId = id
            case .save: save()
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
    
    private func save() {
        guard let client = state.clients.data?.first(
            where: { $0.id == state.selectedClientId }
        ) else { return }
        
        delegate?.didSelectClient(client)
        flowController?.handleFlow(ProjectDetailFlow.pop)
    }
}
