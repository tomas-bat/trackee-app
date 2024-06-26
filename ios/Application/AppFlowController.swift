//
//  Created by Petr Chmelar on 17/07/2018.
//  Copyright © 2018 Matee. All rights reserved.
//

import Factory
import Onboarding
import SharedDomain
import UIKit
import UIToolkit

final class AppFlowController: FlowController, MainFlowControllerDelegate, OnboardingFlowControllerDelegate {
    
    // MARK: - Dependencies
    
    @Injected(\.isLoggedInUseCase) private var isLoggedInUseCase
    @Injected(\.logoutUseCase) private var logoutUseCase
    
    // MARK: - Flow handling
    
    func start() {
        setupAppearance()
        
        let loadingView = ApplicationLoadingView()
        let loadingVC = BaseHostingController(rootView: loadingView)
        navigationController.viewControllers = [loadingVC]
        
        Task {
            let isLoggedIn: Bool = (try? await isLoggedInUseCase.execute()) ?? false
            
            if isLoggedIn {
                setupMain()
            } else {
                presentOnboarding(
                    message: nil,
                    animated: false,
                    completion: nil
                )
            }
        }
    }
    
    func setupMain() {
        let fc = MainFlowController(navigationController: navigationController)
        fc.delegate = self
        let rootVC = startChildFlow(fc)
        navigationController.viewControllers = [rootVC]
    }
    
    func presentOnboarding(
        message: String?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let nc = BaseNavigationController()
        let fc = OnboardingFlowController(
            message: message,
            navigationController: nc
        )
        fc.delegate = self
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.isHidden = false
        navigationController.present(nc, animated: animated, completion: completion)
    }
    
    public func handlePushNotification(_ notification: [AnyHashable: Any]) {
        guard let main = childControllers.first(where: { $0 is MainFlowController }) as? MainFlowController else { return }
        do {
//            let notification = try handlePushNotificationUseCase.execute(notification)
//            main.handleDeeplink(for: notification)
        } catch {}
    }
    
    public func handleLogout() {
        Task {
            do {
                try await logoutUseCase.execute()
                self.presentOnboarding(
                    message: L10n.dialog_interceptor_text,
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    private func setupAppearance() {
        // Navigation bar
        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor(AppTheme.Colors.navBarBackground)
//        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(AppTheme.Colors.navBarTitle)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().tintColor = UIColor(AppTheme.Colors.navBarTitle)

        // Tab bar
//        UITabBar.appearance().tintColor = UIColor(AppTheme.Colors.primaryColor)

        // UITextField
//        UITextField.appearance().tintColor = UIColor(AppTheme.Colors.primaryColor)
    }
}
