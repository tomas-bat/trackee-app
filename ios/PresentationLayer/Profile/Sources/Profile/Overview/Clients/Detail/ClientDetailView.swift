//
//  Created by Tomáš Batěk on 03.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ClientDetailView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    private let labelMinWidth: CGFloat = 80
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ClientDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: ClientDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state.client {
                case let .data(client), let .loading(client):
                        List {
                            Section {
                                fieldRow(
                                    label: L10n.client_detail_view_name_label,
                                    placeholder: L10n.client_detail_view_name_placeholder,
                                    text: Binding<String>(
                                        get: { viewModel.state.name },
                                        set: { name in viewModel.onIntent(.changeName(to: name)) }
                                    )
                                )
                            }
                            
                            if !viewModel.state.isCreating {
                                Section {
                                    Button(L10n.client_detail_remove_client) {
                                        viewModel.onIntent(.remove)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(AppTheme.Colors.destructive)
                                }
                            }
                        }
                        .skeleton(viewModel.state.client.isLoading)
                        .scrollBounceBehavior(.basedOnSize)
                case let .error(error):
                    ErrorView(error: error)
                        .padding(padding)
                case .empty: EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.Colors.background)
            .navigationTitle(navigationTitle)
            .toolbar(.visible)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        viewModel.onIntent(.cancel)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(L10n.save_label) {
                        viewModel.onIntent(.save)
                    }
                }
            }
        }
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private var navigationTitle: String {
        viewModel.state.isCreating ? L10n.client_detail_new_client_title : L10n.client_detail_edit_client_title
    }
    
    private func fieldRow(
        label: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .frame(minWidth: labelMinWidth, alignment: .leading)
            
            TextField(placeholder, text: text)
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Container.shared.registerUseCaseMocks()
    Environment.locale = .init(identifier: "cs")
    
    let vm = ClientDetailViewModel(
        id: UUID().uuidString,
        isCreating: false
    )
    
    return Text("Base view")
        .sheet(isPresented: .constant(true)) {
            ClientDetailView(viewModel: vm)
        }
}
#endif
