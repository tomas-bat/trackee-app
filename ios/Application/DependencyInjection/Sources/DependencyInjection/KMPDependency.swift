//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import KMPSharedDomain
import Foundation
import OSLog
import Utilities
import Factory
import protocol AuthProvider.AuthProvider
import protocol AppleSignInProvider.AppleSignInProvider

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
        authProvider: AuthProvider = Container.shared.authProvider.resolve()
    ) {
        let onStartup = {
            Logger.app.info("Koin Started")
        }
        
        guard let appleSignInProvider = appleSignInProvider as? KMPSharedDomain.AppleSignInProvider,
              let authProvider = authProvider as? KMPSharedDomain.AuthProvider
        else {
            fatalError("Failed to cast Swift provider interface to Kotlin provider interface")
            return
        }
        
        let koinApplication = KoinIOSKt.doInitKoinIos(
            doOnStartup: onStartup,
            appleSignInProvider: appleSignInProvider,
            authProvider: authProvider
        )
        _koin = koinApplication.koin
    }
    
    func get<T: AnyObject>(_ proto: Protocol) -> T {
        _koin?.get(objCProtocol: proto) as! T // swiftlint:disable:this force_cast
    }
}
