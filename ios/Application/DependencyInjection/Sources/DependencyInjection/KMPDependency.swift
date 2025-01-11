//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import KMPSharedDomain
import Foundation
import OSLog
import Utilities
import Factory
import AuthProvider
import AppleSignInProvider
import protocol AppInfoProvider.AppInfoProvider
import InAppPurchaseProvider

extension Container {
    var kmp: Factory<KMPDependency> { self { KMPKoinDependency() }.singleton }
}

protocol KMPDependency {
    func get<T: AnyObject>(_ proto: Protocol) -> T
}

final class KMPKoinDependency: KMPDependency {
    
    private var _koin: Koin_coreKoin?
    
    init() {
        startKoin()
    }
    
    private func startKoin(
        appleSignInProvider: AppleSignInProvider = Container.shared.appleSignInProvider.resolve(),
        authProvider: AuthProvider = Container.shared.authProvider.resolve(),
        appInfoProvider: AppInfoProvider = Container.shared.appInfoProvider.resolve(),
        inAppPurchaseProvider: InAppPurchaseProvider = Container.shared.inAppPurchaseProvider.resolve()
    ) {
        let onStartup = {
            Logger.app.info("Koin Started")
        }
        
        guard let appInfoProvider = appInfoProvider as? KMPSharedDomain.AppInfoProvider else {
            fatalError("Failed to cast Swift provider interface to Kotlin provider interface")
            return
        }
        
        let koinApplication = KoinIOSKt.doInitKoinIos(
            doOnStartup: onStartup,
            appleSignInProvider: appleSignInProvider,
            authProvider: authProvider,
            appInfoProvider: appInfoProvider,
            inAppPurchaseProvider: inAppPurchaseProvider
        )
        _koin = koinApplication.koin
    }
    
    func get<T: AnyObject>(_ proto: Protocol) -> T {
        _koin?.get(objCProtocol: proto) as! T // swiftlint:disable:this force_cast
    }
}
