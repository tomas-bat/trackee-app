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
}

public final class PaywallViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getPurchasePackagesUseCase) private var getPurchasePackagesUseCase
    @Injected(\.purchasePackageUseCase) private var purchasePackageUseCase
    @Injected(\.getIsPackageEligibleForIntroductoryDiscountUseCase) private var getIsPackageEligibleForIntroductoryDiscountUseCase
    
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
    }
    
    public func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .purchasePackage(packageId): await purchasePackage(packageId: packageId)
            case .retry: await fetchPaywall(showLoading: true)
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
}
