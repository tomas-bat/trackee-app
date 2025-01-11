//
//  Created by Petr Chmelar on 22.05.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain

final class ProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.logoutUseCase) private var logoutUseCase
    @Injected(\.deleteUserUseCase) private var deleteUserUseCase
    @Injected(\.getUserEmailUseCase) private var getUserEmailUseCase
    @Injected(\.restorePurchasesUseCase) private var restorePurchasesUseCase
    
    // MARK: - Init
    
    init(flowController: FlowController?) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task {
            await fetchData(showLoading: !state.email.hasData)
        })
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var email: ViewData<String> = .loading(mock: .randomString(length: 16))
        var deleteLoading = false
        var logoutLoading = false
        var restorePurchasesLoading = false
        var alertData: AlertData?
        
        var disabled: Bool {
            deleteLoading || logoutLoading || restorePurchasesLoading
        }
    }
    
    // MARK: - Intent
    enum Intent {
        case logout
        case showClients
        case showProjects
        case deleteAccount
        case changeAlertData(to: AlertData?)
        case restorePurchases
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .logout: await logout()
            case .showClients: flowController?.handleFlow(ProfileFlow.overview(.showClients))
            case .showProjects: flowController?.handleFlow(ProfileFlow.overview(.showProjects))
            case .deleteAccount: showDeleteAccountAlert()
            case let .changeAlertData(data): state.alertData = data
            case .restorePurchases: await restorePurchases()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData(showLoading: Bool) async {
        if showLoading {
            state.email = .loading(mock: .randomString(length: 16))
        }
        
        await execute {
            let email: String = try await getUserEmailUseCase.execute()
            state.email = .data(email)
        } onError: { error in
            state.email = .error(error)
        }
    }
    
    private func logout() async {
        state.logoutLoading = true
        defer { state.logoutLoading = false }
        
        await execute {
            try await logoutUseCase.execute()
            flowController?.handleFlow(ProfileFlow.overview(
                .presentOnboarding(message: L10n.login_view_logged_out_info)
            ))
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(
                .error(
                    message: error.localizedDescription,
                    actionLabel: nil
                )
            )
        }
    }
    
    private func showDeleteAccountAlert() {
        state.alertData = AlertData(
            title: L10n.profile_view_delete_user_alert_title,
            message: L10n.profile_view_delete_user_alert_message,
            primaryAction: .init(
                title: L10n.yes,
                style: .destruction
            ) { [weak self] in
                self?.executeTask(Task {
                    await self?.deleteAccount()
                })
            },
            secondaryAction: .init(
                title: L10n.cancel,
                style: .cancel
            )
        )
    }
    
    private func deleteAccount() async {
        state.deleteLoading = true
        defer { state.deleteLoading = false }
        
        await execute {
            try await deleteUserUseCase.execute()
            try await logoutUseCase.execute()
            flowController?.handleFlow(ProfileFlow.overview(
                .presentOnboarding(message: L10n.login_view_account_deleted_info)
            ))
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
    private func restorePurchases() async {
        state.restorePurchasesLoading = true
        defer { state.restorePurchasesLoading = false }
        
        await execute {
            try await restorePurchasesUseCase.execute()
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.info(message: L10n.profile_view_purchases_restored_title))
        } onError: { error in
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
}
