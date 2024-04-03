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

final class ClientDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    
    
    private weak var flowController: FlowController?
    
    // MARK: - Stored properties
    
    private let id: String
    
    // MARK: - Init
    
    init(
        id: String,
        isCreating: Bool,
        flowController: FlowController? = nil
    ) {
        self.id = id
        self.flowController = flowController
        super.init()
        state.isCreating = isCreating
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: state.client.isLoading)
        })
    }
    
    // MARK: - State
    
    struct State {
        var client: ViewData<Client> = .loading(mock: .stub())
        var isCreating = false
        var name = ""
    }
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Intent
    
    enum Intent {
        case changeName(to: String)
        case remove
        case cancel
        case save
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeName(name): state.name = name
            case .remove: ()
            case .cancel: ()
            case .save: ()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool) async {
        if showLoading {
            state.client = .loading(mock: .stub())
        }
        
        do {
            try await Task.sleep(for: .seconds(2))
            let client = Client.stub()
            state.client = .data(client)
            state.name = client.name
        } catch {
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
}
