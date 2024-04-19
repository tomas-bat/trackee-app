//
//  Created by Petr Chmelar on 13/04/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import Integrations
import Profile
import SharedDomain
import Timer
import UIKit
import UIToolkit

enum MainTab: Int {
    case timer
    case integrations
    case profile
}

protocol MainFlowControllerDelegate: AnyObject {
    func presentOnboarding(
        message: String?,
        animated: Bool,
        completion: (() -> Void)?
    )
}

final class MainFlowController: FlowController, ProfileFlowControllerDelegate, TimerFlowControllerDelegate {
    
    weak var delegate: MainFlowControllerDelegate?
    
    override func setup() -> UIViewController {
        let main = UITabBarController()
        main.viewControllers = [setupTimerTab(), setupIntegrationsTab(), setupProfileTab()]
        return main
    }
    
    private func setupTimerTab() -> UINavigationController {
        let timerNC = BaseNavigationController()
        timerNC.tabBarItem = UITabBarItem(
            title: L10n.bottom_bar_timer,
            image: UIImage(systemSymbol: .timer),
            tag: MainTab.timer.rawValue
        )
        let timerFC = TimerFlowController(navigationController: timerNC)
        timerFC.delegate = self
        let rootVC = startChildFlow(timerFC)
        timerNC.viewControllers = [rootVC]
        return timerNC
    }
    
    private func setupIntegrationsTab() -> UINavigationController {
        let integrationsNC = BaseNavigationController()
        integrationsNC.tabBarItem = UITabBarItem(
            title: L10n.bottom_bar_integrations,
            image: UIImage(systemSymbol: .point3ConnectedTrianglepathDotted),
            tag: MainTab.integrations.rawValue
        )
        let integrationsFC = IntegrationsFlowController(navigationController: integrationsNC)
        let integrationsRootVC = startChildFlow(integrationsFC)
        integrationsNC.viewControllers = [integrationsRootVC]
        return integrationsNC
    }
    
    private func setupProfileTab() -> UINavigationController {
        let profileNC = BaseNavigationController()
        profileNC.tabBarItem = UITabBarItem(
            title: L10n.bottom_bar_profile,
            image: Asset.Images.profileTabBar.uiImage,
            tag: MainTab.profile.rawValue
        )
        let profileFC = ProfileFlowController(navigationController: profileNC)
        profileFC.delegate = self
        let profileRootVC = startChildFlow(profileFC)
        profileNC.viewControllers = [profileRootVC]
        return profileNC
    }
    
    func presentOnboarding(message: String?) {
        delegate?.presentOnboarding(
            message: message,
            animated: true
        ) { [weak self] in
            self?.navigationController.viewControllers = []
            self?.stopFlow()
        }
    }
    
    @discardableResult private func switchTab(_ index: MainTab) -> FlowController? {
        guard let tabController = rootViewController as? UITabBarController,
            let tabs = tabController.viewControllers, index.rawValue < tabs.count else { return nil }
        tabController.selectedIndex = index.rawValue
        return childControllers[index.rawValue]
    }
    
//    func handleDeeplink(for notification: PushNotification) {
//        switch notification.type {
//        case .userDetail: handleUserDetailDeeplink(userId: notification.entityId)
//        default: return
//        }
//    }
//    
//    private func handleUserDetailDeeplink(userId: String) {
//        guard let usersFlowController = switchTab(.users) as? UsersFlowController else { return }
//        usersFlowController.handleUserDetailDeeplink(userId: userId)
//    }
}
