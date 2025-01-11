//
//  Created by Tomáš Batěk on 20.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain
import SwiftUI
import Factory
import DependencyInjection

public protocol PaywallViewModelDelegate: AnyObject {
    func didPurchasePackage(_ package: PurchasePackage)
    func didDismiss()
    func didRestorePurchases() async
}

public extension PaywallViewModelDelegate {
    func didDismiss() {
        // Not required
    }
}

public final class PaywallViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getPurchasePackagesUseCase) private var getPurchasePackagesUseCase
    @Injected(\.purchasePackageUseCase) private var purchasePackageUseCase
    @Injected(\.getIsPackageEligibleForIntroductoryDiscountUseCase) private var getIsPackageEligibleForIntroductoryDiscountUseCase
    @Injected(\.restorePurchasesUseCase) private var restorePurchasesUseCase
    @Injected(\.getPrivacyPolicyUrlUseCase) private var getPrivacyPolicyUrlUseCase
    @Injected(\.getTermsAndConditionsUrlUseCase) private var getTermsAndConditionsUrlUseCase
    
    // MARK: - Stored properties
    
    public weak var delegate: PaywallViewModelDelegate?
    
    // MARK: - Init
    
    public init(flowController: FlowController?) {
        self.flowController = flowController
    }
    
    // MARK: - State
    
    public struct State {
        var purchasePackages: ViewData<[PaywallPackageViewObject]> = .loading(mock: .stub)
        var purchaseLoading = false
        var restorePurchasesLoading = false
        var termsAndConditionsLoading = false
        var privacyPolicyLoading = false
    }
    
    @Published public private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    // MARK: - Lifecycle
    
    public override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchPaywall(showLoading: !state.purchasePackages.hasData)
        })
    }
    
    // MARK: - Intent
    
    public enum Intent {
        case purchasePackage(packageId: String)
        case retry
        case cancel
        case restorePurchases
        case showTermsAndConditions
        case showPrivacyPolicy
    }
    
    public func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .purchasePackage(packageId): await purchasePackage(packageId: packageId)
            case .retry: await fetchPaywall(showLoading: true)
            case .cancel: delegate?.didDismiss()
            case .restorePurchases: await restorePurchases()
            case .showTermsAndConditions: await showTermsAndConditions()
            case .showPrivacyPolicy: await showPrivacyPolicy()
            }
        })
    }
    
    // MARK: - Private
    
    private func purchasePackage(packageId: String) async {
        state.purchaseLoading = true
        defer { state.purchaseLoading = false }
        
        guard let package = state.purchasePackages.data?.first(
            where: { $0.package.id == packageId}
        ) else { return }
        
        await execute {
            let params = PurchasePackageUseCaseParams(packageId: packageId)
            try await purchasePackageUseCase.execute(params: params)
            delegate?.didPurchasePackage(package.package)
        } onError: { error in
            state.purchasePackages = .error(error)
        }
    }
    
    private func fetchPaywall(showLoading: Bool) async {
        if showLoading {
            state.purchasePackages = .loading(mock: .stub)
        }
        
        await execute {
            let packages: [PurchasePackage] = try await getPurchasePackagesUseCase.execute()
            let viewObjects = try await packages.asyncMap { package in
                let params = GetIsPackageEligibleForIntroductoryDiscountUseCaseParams(
                    packageId: package.id
                )
                
                return PaywallPackageViewObject(
                    package: package,
                    isEligibleForIntroductoryDiscount: try await getIsPackageEligibleForIntroductoryDiscountUseCase.execute(
                        params: params
                    )
                )
            }
            
            if packages.isEmpty {
                state.purchasePackages = .empty(.noData)
            } else {
                state.purchasePackages = .data(viewObjects)
            }
        } onError: { error in
            state.purchasePackages = .error(error)
        }
    }
    
    private func restorePurchases() async {
        state.restorePurchasesLoading = true
        defer { state.restorePurchasesLoading = false }
        
        await execute {
            try await restorePurchasesUseCase.execute()
            snackState.currentData?.dismiss()
            await snackState.showSnack(.info(message: L10n.paywall_purchases_restored_title))
            await delegate?.didRestorePurchases()
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func showTermsAndConditions() async {
        state.termsAndConditionsLoading = true
        defer { state.termsAndConditionsLoading = false }
        
        await execute {
            let string: String = try await getTermsAndConditionsUrlUseCase.execute()
            guard let url = URL(string: string) else { return }
            await UIApplication.shared.open(url)
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func showPrivacyPolicy() async {
        state.privacyPolicyLoading = true
        defer { state.privacyPolicyLoading = false }
        
        await execute {
            let string: String = try await getPrivacyPolicyUrlUseCase.execute()
            guard let url = URL(string: string) else { return }
            await UIApplication.shared.open(url)
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
}
