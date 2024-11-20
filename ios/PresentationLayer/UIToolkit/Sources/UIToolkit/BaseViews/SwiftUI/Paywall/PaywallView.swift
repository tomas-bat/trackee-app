//
//  Created by Tomáš Batěk on 20.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI

public struct PaywallView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PaywallViewModel
    
    // MARK: - Init
    
    public init(viewModel: PaywallViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch viewModel.state.purchasePackages {
            case let .data(packages), let .loading(packages):
                PaywallContentView(
                    origin: .integrations,
                    packages: packages,
                    paymentLoading: viewModel.state.purchaseLoading,
                    onPrivacyPolicyClick: {},
                    onRestorePurchasesClick: {},
                    onContinue: { package in
                        viewModel.onIntent(.purchasePackage(packageId: package.id))
                    }
                )
                .skeleton(viewModel.state.purchasePackages.isLoading)
            case let .error(error):
                errorView(error)
            case .empty:
                EmptyContentView(
                    text: L10n.integrations_view_empty_title
                )
                .padding(padding)
            }
        }
        .disabled(viewModel.state.purchaseLoading)
    }
    
    // MARK: - Private
    
    private func errorView(_ error: Error) -> some View {
        ErrorView(
            error: error,
            onRetryTap: { viewModel.onIntent(.retry) }
        )
        .padding(padding)
    }
}
