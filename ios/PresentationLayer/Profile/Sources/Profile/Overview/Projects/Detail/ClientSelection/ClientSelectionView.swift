//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ClientSelectionView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ClientSelectionViewModel
    
    // MARK: - Init
    
    init(viewModel: ClientSelectionViewModel) {
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
                            
                            Button {
                                viewModel.onIntent(.selectClient(id: client.id))
                            } label: {
                                SelectableClientView(
                                    client: client,
                                    isSelected: client.id == viewModel.state.selectedClientId
                                )
                                .skeleton(viewModel.state.clients.isLoading)
                            }
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
            case .empty:
                EmptyContentView(text: L10n.client_selection_view_no_clients)
                    .padding(padding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
        .navigationTitle(L10n.client_selection_view_title)
        .toolbar(.visible)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.save_label) {
                    viewModel.onIntent(.save)
                }
            }
        }
        .searchable(
            text: Binding<String>(
                get: { viewModel.state.searchText },
                set: { text in viewModel.onIntent(.updateSearchText(to: text)) }
            )
        )
        .lifecycle(viewModel)
    }
}

#if DEBUG
import Factory
import DependencyInjectionMocks
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = ClientSelectionViewModel()
    return ClientSelectionView(viewModel: vm)
}

#endif
