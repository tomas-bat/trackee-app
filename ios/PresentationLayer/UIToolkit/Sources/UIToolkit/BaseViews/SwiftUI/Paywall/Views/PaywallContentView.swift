//
//  Created by Tomáš Batěk on 01.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import KMPSharedDomain

public struct PaywallContentView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 32
    private let innerSpacing: CGFloat = 16
    private let lineSpacing: CGFloat = 8
    private let proSpacing: CGFloat = 4
    private let imageWidth: CGFloat = 86
    private let bestOfferIndex = 0
    private let padding: CGFloat = 16
    private let extraBottomContentPadding: CGFloat = 48
    
    private let pros = [
        L10n.paywall_pro_1,
        L10n.paywall_pro_2,
        L10n.paywall_pro_3,
        L10n.paywall_pro_4
    ]
    
    // MARK: - Stored properties
    
    private let origin: PaywallViewOrigin
    private let packages: [PaywallPackageViewObject]
    private let paymentLoading: Bool
    private let privacyPolidyLoading: Bool
    private let termsAndConditionsLoading: Bool
    private let restorePurchasesLoading: Bool
    private let onPrivacyPolicyClick: () -> Void
    private let onTermsAndConditionsClick: () -> Void
    private let onRestorePurchasesClick: () -> Void
    private let onContinue: (PurchasePackage) -> Void
    
    @State private var selectedPackage: PaywallPackageViewObject?
    @State private var badgeHeight: CGFloat = 0
    
    // MARK: - Init
    
    public init(
        origin: PaywallViewOrigin,
        packages: [PaywallPackageViewObject],
        paymentLoading: Bool,
        restorePurchasesLoading: Bool,
        privacyPolidyLoading: Bool,
        termsAndConditionsLoading: Bool,
        onPrivacyPolicyClick: @escaping () -> Void,
        onTermsAndConditionsClick: @escaping () -> Void,
        onRestorePurchasesClick: @escaping () -> Void,
        onContinue: @escaping (PurchasePackage) -> Void
    ) {
        self.origin = origin
        self.packages = packages
        self.paymentLoading = paymentLoading
        self.privacyPolidyLoading = privacyPolidyLoading
        self.termsAndConditionsLoading = termsAndConditionsLoading
        self.restorePurchasesLoading = restorePurchasesLoading
        self.onPrivacyPolicyClick = onPrivacyPolicyClick
        self.onTermsAndConditionsClick = onTermsAndConditionsClick
        self.onRestorePurchasesClick = onRestorePurchasesClick
        self.onContinue = onContinue
    }
    
    // MARK: - Body
    
    public var body: some View {
        CenteredScrollView {
            VStack(alignment: .center, spacing: spacing) {
                Image(systemSymbol: .point3FilledConnectedTrianglepathDotted)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
                
                VStack(alignment: .center, spacing: innerSpacing) {
                    Text(title)
                        .font(AppTheme.Fonts.headline)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: lineSpacing) {
                        ForEach(pros, id: \.self) { pro in
                            HStack(alignment: .firstTextBaseline, spacing: proSpacing) {
                                Image(systemSymbol: .checkmark)
                                    .renderingMode(.template)
                                    .foregroundStyle(AppTheme.Colors.success)
                                
                                Text(pro)
                                    .font(AppTheme.Fonts.body)
                            }
                        }
                    }
                }
                
                VStack(alignment: .center, spacing: innerSpacing) {
                    VStack(alignment: .center, spacing: lineSpacing) {
                        ForEach(0..<packages.count, id: \.self) { idx in
                            let package = packages[idx]
                            
                            Button {
                                selectedPackage = package
                            } label: {
                                packageLabel(for: package.package)
                            }
                            .buttonStyle(
                                SelectableButtonStyle(
                                    selected: selectedPackage == package,
                                    badge: {
                                        if idx == bestOfferIndex {
                                            Badge(
                                                text: L10n.paywall_best_offer,
                                                image: Image(systemSymbol: .starFill)
                                            )
                                            .readSize { size in
                                                badgeHeight = size.height
                                            }
                                            .offset(y: -badgeHeight / 2)
                                        }
                                    }
                                )
                            )
                            .font(AppTheme.Fonts.headline)
                        }
                    }
                    
                    VStack(alignment: .center, spacing: .zero) {
                        Text(L10n.paywall_trial_info)
                        
                        Text(L10n.paywall_integration_disclaimer)
                    }
                    .multilineTextAlignment(.center)
                    .font(AppTheme.Fonts.index)
                    
                    VStack(alignment: .center, spacing: lineSpacing) {
                        HStack(alignment: .center, spacing: spacing) {
                            Button(L10n.paywall_privacy_policy, action: onPrivacyPolicyClick)
                                .environment(\.isLoading, privacyPolidyLoading)
                            
                            Button(L10n.paywall_terms_and_conditions, action: onTermsAndConditionsClick)
                                .environment(\.isLoading, termsAndConditionsLoading)
                        }
                        
                        Button(L10n.paywall_restore_purchases, action: onRestorePurchasesClick)
                            .environment(\.isLoading, restorePurchasesLoading)
                    }
                    .buttonStyle(.additional)
                }
            }
            .padding(padding)
            .padding(.bottom, extraBottomContentPadding)
        }
        .scrollBounceBehavior(.basedOnSize)
        .overlay(alignment: .bottom) {
            Button(continueTitle) {
                if let selectedPackage {
                    onContinue(selectedPackage.package)
                }
            }
            .buttonStyle(.primary(backgroundColor: AppTheme.Colors.success))
            .padding(padding)
            .disabled(selectedPackage == nil)
            .opacity(selectedPackage == nil ? 0.5 : 1)
            .environment(\.isLoading, paymentLoading)
        }
        .foregroundStyle(AppTheme.Colors.foreground)
        .background(AppTheme.Colors.background)
        .onAppear {
            selectedPackage = packages.first
        }
    }
    
    private var title: String {
        switch origin {
        case .generic: L10n.paywall_title
        case .integrations: L10n.paywall_title_integrations
        case let .clients(count):
            switch count {
            case 1: L10n.paywall_title_clients_one
            case 2,3,4: L10n.paywall_title_clients_few(count)
            default: L10n.paywall_title_clients_many(count)
            }
        case let .projects(count):
            switch count {
            case 1: L10n.paywall_title_projects_one
            case 2,3,4: L10n.paywall_title_projects_few(count)
            default: L10n.paywall_title_projects_many(count)
            }
        }
    }
    
    @ViewBuilder
    private func packageLabel(
        for package: PurchasePackage
    ) -> some View {
        if let period = package.product.subscriptionPeriod {
            Text("\(period.localized(for: package.localizedPrice))*")
        } else {
            Text("\(package.localizedPrice)*")
        }
    }
    
    private var continueTitle: String {
        if selectedPackage?.isEligibleForIntroductoryDiscount == true {
            L10n.paywall_start_free_trial
        } else {
            L10n.continue_label
        }
    }
}

#if DEBUG
#Preview {
    PaywallContentView(
        origin: .generic,
        packages: [PaywallPackageViewObject].stub,
        paymentLoading: false,
        restorePurchasesLoading: false,
        privacyPolidyLoading: false,
        termsAndConditionsLoading: false,
        onPrivacyPolicyClick: {},
        onTermsAndConditionsClick: {},
        onRestorePurchasesClick: {},
        onContinue: { _ in }
    )
    .background(AppTheme.Colors.background)
}
#endif
