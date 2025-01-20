//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit
import KMPSharedDomain

struct IntegrationsOverviewView: View {
    
    // MARK: - Constants
    
    private let imageSize: CGFloat = 20
    private let padding: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: IntegrationsOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: IntegrationsOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.showPaywall {
            case let .data(showPaywall), let .loading(showPaywall):
                if showPaywall {
                    PaywallView(
                        paywallViewOrigin: .integrations,
                        viewModel: viewModel.paywallViewModel,
                        isNested: true
                    )
                } else {
                    integrationsView
                }
            case let .error(error):
                errorView(error)
            case .empty: EmptyView()
            }
        }
        .confirmationDialog(
            L10n.integrations_view_select_type_dialog_title,
            isPresented: isShowingTypes,
            titleVisibility: .visible,
            actions: dialogActions
        )
        .animateContent(viewModel.state.integrations.isLoading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(AppTheme.Colors.foreground)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(L10n.integrations_view_title)
        .toolbar(.visible)
        .toolbar {
            if viewModel.state.showPaywall.data == false {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.onIntent(.addIntegration)
                    } label: {
                        Image(systemSymbol: .plus)
                    }
                }
            }
        }
        .snack(viewModel.snackState)
        .background(AppTheme.Colors.background)
        .lifecycle(viewModel.paywallViewModel)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private var isShowingTypes: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.state.isShowingTypes },
            set: { isShowing in viewModel.onIntent(.changeShowingTypes(to: isShowing)) }
        )
    }
    
    @ViewBuilder
    private var integrationsView: some View {
        switch viewModel.state.integrations {
        case let .data(integrations), let .loading(integrations):
            List {
                ForEach(integrations.indices, id: \.self) { idx in
                    let integration = integrations[idx]
                    
                    Button {
                        viewModel.onIntent(.showIntegrationDetail(id: integration.id))
                    } label: {
                        HStack {
                            integration.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize, height: imageSize)
                            
                            Text(integration.label)
                            
                            Spacer()
                            
                            Image(systemSymbol: .chevronRight)
                        }
                    }
                    .skeleton(viewModel.state.integrations.isLoading)
                }
            }
        case let .error(error):
            errorView(error)
        case .empty:
            EmptyContentView(
                text: L10n.integrations_view_empty_title,
                action: .init(
                    label: L10n.integrations_view_add_integration,
                    image: Image(systemSymbol: .plus),
                    action: { viewModel.onIntent(.addIntegration) }
                )
            )
            .padding(padding)
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        ErrorView(
            error: error,
            onRetryTap: { viewModel.onIntent(.retry) }
        )
        .padding(padding)
    }
    
    private func dialogActions() -> some View {
        ForEach(IntegrationType.allCases.indices, id: \.self) { idx in
            let type = IntegrationType.allCases[idx]
            
            Button(type.name) {
                viewModel.onIntent(.selectNewIntegrationType(type))
            }
        }
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Container.shared.registerUseCaseMocks()
    Environment.locale = .init(identifier: "cs")
    
    let vm = IntegrationsOverviewViewModel(
        paywallViewModel: PaywallViewModel(flowController: nil),
        flowController: nil
    )
    return NavigationStack {
        IntegrationsOverviewView(
            viewModel: vm
        )
    }
}

#endif
