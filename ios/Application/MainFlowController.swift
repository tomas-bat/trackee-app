//
//  Created by Petr Chmelar on 13/04/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import Profile
import SharedDomain
import UIKit
import UIToolkit

enum MainTab: Int {
    case profile
}

protocol MainFlowControllerDelegate: AnyObject {
    func presentOnboarding(animated: Bool, completion: (() -> Void)?)
}

final class MainFlowController: FlowController, ProfileFlowControllerDelegate {
    
    weak var delegate: MainFlowControllerDelegate?
    
    override func setup() -> UIViewController {
        let main = UITabBarController()
        main.viewControllers = [setupProfileTab()]
        return main
    }
    
    private func setupProfileTab() -> UINavigationController {
        let profileNC = BaseNavigationController(statusBarStyle: .lightContent)
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
    
    func presentOnboarding() {
        delegate?.presentOnboarding(animated: true, completion: { [weak self] in
            self?.navigationController.viewControllers = []
            self?.stopFlow()
        })
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
