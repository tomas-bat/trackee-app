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
            case let .updateSearchText(text): state.searchText = text
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
        
        do {
            let clients: [Client] = try await getClientsUseCase.execute()
            
            if clients.isEmpty {
                state.clients = .empty
            } else {
                state.clients = .data(clients)
            }
        } catch {
            state.clients = .error(error)
        }
    }
    
    private func showClientDetail(clientId: String) {
        
    }
    
    private func addClient() {
        
    }
}
