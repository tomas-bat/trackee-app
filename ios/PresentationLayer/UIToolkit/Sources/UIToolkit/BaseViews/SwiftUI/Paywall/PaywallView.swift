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
    
    private let isNested: Bool
    private let paywallViewOrigin: PaywallViewOrigin
    
    // MARK: - Init
    
    public init(
        paywallViewOrigin: PaywallViewOrigin,
        viewModel: PaywallViewModel,
        isNested: Bool = false
    ) {
        self.paywallViewOrigin = paywallViewOrigin
        self.viewModel = viewModel
        self.isNested = isNested
    }
    
    // MARK: - Body
    
    public var body: some View {
        if isNested {
            content
        } else {
            NavigationStack {
                content
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(L10n.cancel) {
                                viewModel.onIntent(.cancel)
                            }
                        }
                    }
                    .interactiveDismissDisabled()
            }
            .lifecycle(viewModel)
            .foregroundStyle(AppTheme.Colors.foreground)
        }
    }
    
    // MARK: - Private
    
    private var content: some View {
        Group {
            switch viewModel.state.purchasePackages {
            case let .data(packages), let .loading(packages):
                PaywallContentView(
                    origin: paywallViewOrigin,
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
    
    private func errorView(_ error: Error) -> some View {
        ErrorView(
            error: error,
            onRetryTap: { viewModel.onIntent(.retry) }
        )
        .padding(padding)
    }
}
