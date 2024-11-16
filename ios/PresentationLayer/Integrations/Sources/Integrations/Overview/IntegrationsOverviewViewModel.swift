//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain
import SharedDomainMocks

final class IntegrationsOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Constants
    
    private let messageDelay: TimeInterval = 0.5
    
    // MARK: - Dependencies
    
    @Injected(\.getIntegrationsUseCase) private var getIntegrationsUseCase
    @Injected(\.getHasFullAccessUseCase) private var getHasFullAccessUseCase
    @Injected(\.getPurchasePackagesUseCase) private var getPurchasePackagesUseCase
    @Injected(\.purchasePackageUseCase) private var purchasePackageUseCase
    @Injected(\.getIsPackageEligibleForIntroductoryDiscountUseCase) private var getIsPackageEligibleForIntroductoryDiscountUseCase
    
    private weak var flowController: FlowController?
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: !state.integrations.hasData)
        })
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var integrations: ViewData<[Integration]> = .loading(mock: .stub)
        var isShowingTypes = false
        var showPaywall: ViewData<Bool> = .loading(mock: false)
        var purchasePackages: ViewData<[PaywallPackageViewObject]> = .loading(mock: .stub)
        var purchaseLoading = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        case retry
        case addIntegration
        case selectNewIntegrationType(IntegrationType)
        case showIntegrationDetail(id: String)
        case changeShowingTypes(to: Bool)
        case purchasePackage(packageId: String)
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .retry: await fetchData(showLoading: true)
            case .addIntegration: addIntegration()
            case let .showIntegrationDetail(id): showIntegrationDetail(integrationId: id)
            case let .changeShowingTypes(isShowing): state.isShowingTypes = isShowing
            case let .selectNewIntegrationType(type): selectNewIntegrationType(type)
            case let .purchasePackage(packageId): await purchasePackage(packageId: packageId)
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool) async {
        if showLoading {
            state.showPaywall = .loading(mock: false)
            state.integrations = .loading(mock: .stub)
        }
        
        await execute {
            let hasFullAccess: KotlinBoolean = try await getHasFullAccessUseCase.execute()
            state.showPaywall = .data(!hasFullAccess.boolValue)
            
            if hasFullAccess.boolValue {
                await fetchIntegrations(showLoading: showLoading)
            } else {
                await fetchPaywall(showLoading: showLoading)
            }
        } onError: { error in
            state.integrations = .error(error)
        }
    }
    
    private func fetchIntegrations(showLoading: Bool) async {
        if showLoading {
            state.integrations = .loading(mock: .stub)
        }
        
        await execute {
            let integrations: [Integration] = try await getIntegrationsUseCase.execute()
            
            if integrations.isEmpty {
                state.integrations = .empty(.noData)
            } else {
                state.integrations = .data(integrations)
            }
        } onError: { error in
            state.integrations = .error(error)
        }
    }
    
    private func addIntegration() {
        state.isShowingTypes = true
    }
    
    private func showIntegrationDetail(integrationId: String) {
        flowController?.handleFlow(IntegrationsFlow.overview(.showIntegrationDetail(
            integrationId: integrationId,
            delegate: self
        )))
    }
    
    private func selectNewIntegrationType(_ type: IntegrationType) {
        flowController?.handleFlow(IntegrationsFlow.overview(.showNewIntegration(
            integrationType: type,
            delegate: self
        )))
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
    
    private func purchasePackage(packageId: String) async {
        state.purchaseLoading = true
        defer { state.purchaseLoading = false }
        
        await execute {
            let params = PurchasePackageUseCaseParams(packageId: packageId)
            try await purchasePackageUseCase.execute(params: params)
        } onError: { error in
            state.showPaywall = .error(error)
        }
    }
}

// MARK: IntegrationDetailViewModelDelegate

extension IntegrationsOverviewViewModel: IntegrationDetailViewModelDelegate {
    func didUpdateIntegration() async {
        await fetchData(showLoading: false)
    }
    
    func didDeleteIntegration(named integrationName: String) {
        Task.delayed(byTimeInterval: messageDelay) { [weak self] in
            self?.snackState.currentData?.dismiss()
            self?.snackState.showSnackSync(.info(
                message: "\(L10n.integration_view_removed_snack_title_part_one) \(integrationName) \(L10n.integration_view_removed_snack_title_part_two)"
            ))
        }
    }
}
