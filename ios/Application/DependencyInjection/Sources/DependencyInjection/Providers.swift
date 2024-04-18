//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import AnalyticsProvider
import Factory
import KeychainProvider
import LocationProvider
import NetworkProvider
import PushNotificationsProvider
import RemoteConfigProvider
import UIKit
import UserDefaultsProvider
import Utilities
import AppleSignInProvider
import AuthProvider
import AppInfoProvider

public extension Container {
    var appleSignInProvider: Factory<AppleSignInProvider> { self { DefaultAppleSignInProvider(presentationAnchor: UIApplication.shared.delegate?.window) } }
    var authProvider: Factory<AuthProvider> { self { FirebaseAuthProvider() } }
    var appInfoProvider: Factory<AppInfoProvider> { self { DefaultAppInfoProvider() } }
    
    var analyticsProvider: Factory<AnalyticsProvider> { self { FirebaseAnalyticsProvider() } }
    var keychainProvider: Factory<KeychainProvider> { self { SystemKeychainProvider() } }
    var locationProvider: Factory<LocationProvider> { self { SystemLocationProvider() } }
    var networkProvider: Factory<NetworkProvider> { self { SystemNetworkProvider(
        readAuthToken: { try self.keychainProvider().read(.authToken) },
        delegate: UIApplication.shared.delegate as? NetworkProviderDelegate
    )}}
    var pushNotificationsProvider: Factory<PushNotificationsProvider> { self { FirebasePushNotificationsProvider(
        application: UIApplication.shared,
        appDelegate: UIApplication.shared.delegate as? (UIApplicationDelegate & UNUserNotificationCenterDelegate)
    )}}
    var remoteConfigProvider: Factory<RemoteConfigProvider> { self { FirebaseRemoteConfigProvider(
        debugMode: Environment.type != .production
    )}}
    var userDefaultsProvider: Factory<UserDefaultsProvider> { self { SystemUserDefaultsProvider() } }
}
