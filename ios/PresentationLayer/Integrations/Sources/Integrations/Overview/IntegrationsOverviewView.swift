//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit

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
            switch viewModel.state.integrations {
            case let .data(integrations), let .loading(integrations):
                List {
                    ForEach(integrations.indices, id: \.self) { idx in
                        let integration = integrations[idx]
                        
                        Button {
                            
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
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.retry) }
                )
                .padding(padding)
            case .empty:
                EmptyContentView(
                    text: L10n.integrations_view_empty_title
                )
                .padding(padding)
            }
        }
        .animateContent(viewModel.state.integrations.isLoading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(AppTheme.Colors.foreground)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(L10n.integrations_view_title)
        .toolbar(.visible)
        .snack(viewModel.snackState)
        .background(AppTheme.Colors.background)
        .lifecycle(viewModel)
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Container.shared.registerUseCaseMocks()
    Environment.locale = .init(identifier: "cs")
    
    let vm = IntegrationsOverviewViewModel(flowController: nil)
    return IntegrationsOverviewView(
        viewModel: vm
    )
}

#endif
