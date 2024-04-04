//
//  Created by Petr Chmelar on 22.05.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit

final class ProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.logoutUseCase) private var logoutUseCase
    @Injected(\.deleteUserUseCase) private var deleteUserUseCase
    
    // MARK: - Init

    init(flowController: FlowController?) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()

    struct State {
        var deleteLoading = false
        var alertData: AlertData?
    }
    
    // MARK: - Intent
    enum Intent {
        case logout
        case showClients
        case showProjects
        case deleteAccount
        case changeAlertData(to: AlertData?)
    }

    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .logout: await logout()
            case .showClients: flowController?.handleFlow(ProfileFlow.overview(.showClients))
            case .showProjects: flowController?.handleFlow(ProfileFlow.overview(.showProjects))
            case .deleteAccount: showDeleteAccountAlert()
            case let .changeAlertData(data): state.alertData = data
            }
        })
    }
    
    // MARK: - Private
    
    private func logout() async {
        do {
            try await logoutUseCase.execute()
            flowController?.handleFlow(ProfileFlow.overview(
                .presentOnboarding(message: L10n.login_view_logged_out_info)
            ))
        } catch {
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
        
        do {
            try await deleteUserUseCase.execute()
            try await logoutUseCase.execute()
            flowController?.handleFlow(ProfileFlow.overview(
                .presentOnboarding(message: L10n.login_view_account_deleted_info)
            ))
        } catch {
            snackState.currentData?.dismiss()
            snackState.showSnackSync(.error(message: error.localizedDescription, actionLabel: nil))
        }
    }
    
}
