//
//  Created by Tomáš Batěk on 01.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import KMPSharedDomain

public struct PaywallView: View {
    
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
    
    private let packages: [PurchasePackage]
    private let paymentLoading: Bool
    private let onPrivacyPolicyClick: () -> Void
    private let onRestorePurchasesClick: () -> Void
    private let onContinue: (PurchasePackage) -> Void
    
    @State private var selectedPackage: PurchasePackage?
    @State private var badgeHeight: CGFloat = 0
    
    // MARK: - Init
    
    public init(
        packages: [PurchasePackage],
        paymentLoading: Bool,
        onPrivacyPolicyClick: @escaping () -> Void,
        onRestorePurchasesClick: @escaping () -> Void,
        onContinue: @escaping (PurchasePackage) -> Void
    ) {
        self.packages = packages
        self.paymentLoading = paymentLoading
        self.onPrivacyPolicyClick = onPrivacyPolicyClick
        self.onRestorePurchasesClick = onRestorePurchasesClick
        self.onContinue = onContinue
        
        selectedPackage = packages.first
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
                    Text(L10n.paywall_title)
                        .font(AppTheme.Fonts.headline)
                    
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
                                packageLabel(for: package)
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
                    
                    HStack(alignment: .center, spacing: spacing) {
                        Button(L10n.paywall_privacy_policy, action: onPrivacyPolicyClick)
                        
                        Button(L10n.paywall_restore_purchases, action: onRestorePurchasesClick)
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
                    onContinue(selectedPackage)
                }
            }
            .buttonStyle(.primary(backgroundColor: AppTheme.Colors.success))
            .padding(padding)
            .disabled(selectedPackage == nil)
            .opacity(selectedPackage == nil ? 0.5 : 1)
        }
        .foregroundStyle(AppTheme.Colors.foreground)
        .background(AppTheme.Colors.background)
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
        if selectedPackage?.product.introductoryDiscount?.price == 0 {
            L10n.paywall_start_free_trial
        } else {
            L10n.continue_label
        }
    }
}

#if DEBUG
#Preview {
    PaywallView(
        packages: [PurchasePackage].stub,
        paymentLoading: false,
        onPrivacyPolicyClick: {},
        onRestorePurchasesClick: {},
        onContinue: { _ in }
    )
    .background(AppTheme.Colors.background)
}
#endif
