//
//  Created by Tomáš Batěk on 27.10.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import RevenueCat
import Utilities
import KMPSharedDomain

public class RevenueCatPurchaseProvider {
    
    private let revenueCatApiKey = "appl_LqBbtMRhjeASbELUpRKDisMQSeX"
    
    private var didInit = false
    
    public init() {
        Purchases.logLevel = if Environment.flavor == .debug { .verbose } else { .warn }
        Purchases.configure(
            withAPIKey: revenueCatApiKey
        )
    }
}

// MARK: - InAppPurchaseProvider

extension RevenueCatPurchaseProvider: InAppPurchaseProvider {
    public func __logIn(userId: String) async throws -> Result<KotlinUnit> {
        _ = try await Purchases.shared.logIn(userId)
        
        return ResultSuccess(data: KotlinUnit())
    }
    
    public func __logOut() async throws -> Result<KotlinUnit> {
        _ = try await Purchases.shared.logOut()
        
        return ResultSuccess(data: KotlinUnit())
    }
}
