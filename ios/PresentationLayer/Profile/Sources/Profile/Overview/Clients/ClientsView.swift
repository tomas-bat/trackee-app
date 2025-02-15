//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ClientsView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ClientsViewModel
    
    // MARK: - Init
    
    init(viewModel: ClientsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.clients {
            case let .data(clients), let .loading(clients):
                ScrollView {
                    LazyVStack(spacing: spacing) {
                        ForEach(0..<clients.count, id: \.self) { idx in
                            let client = clients[idx]
                            
                            ClientRowView(client: client) {
                                viewModel.onIntent(.showClientDetail(clientId: client.id))
                            }
                            .skeleton(viewModel.state.clients.isLoading)
                        }
                    }
                    .animateContent(viewModel.state.clients.isLoading)
                    .padding(padding)
                }
                .scrollBounceBehavior(.basedOnSize)
            case let .error(error):
                ErrorView(error: error) {
                    viewModel.onIntent(.retry)
                }
                .padding(padding)
            case let .empty(reason):
                EmptyContentView(
                    text: emptyTitle(for: reason),
                    action: emptyAction(for: reason)
                )
                .padding(padding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
        .navigationTitle(L10n.clients_view_title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.onIntent(.addClient)
                } label: {
                    Image(systemSymbol: .plus)
                }
                .buttonStyle(.loading)
                .environment(\.isLoading, viewModel.state.addClientLoading)
            }
        }
        .searchable(
            text: Binding<String>(
                get: { viewModel.state.searchText },
                set: { text in viewModel.onIntent(.updateSearchText(to: text)) }
            )
        )
        .snack(viewModel.snackState)
        .lifecycle(viewModel)
    }
    
    private func emptyTitle<T>(for reason: ViewData<T>.EmptyReason) -> String {
        switch reason {
        case .noData: L10n.clients_view_empty_title
        case .search: L10n.empty_list
        }
    }
    
    private func emptyAction<T>(for reason: ViewData<T>.EmptyReason) -> EmptyContentView.Action? {
        switch reason {
        case .noData:
            .init(
                label: L10n.clients_view_add_client_title,
                image: Image(systemSymbol: .plus),
                action: { viewModel.onIntent(.addClient) }
            )
        default: nil
        }
    }
}

#if DEBUG
import Factory
import DependencyInjectionMocks
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = ClientsViewModel()
    return NavigationStack {
        ClientsView(viewModel: vm)
    }
}

#endif
