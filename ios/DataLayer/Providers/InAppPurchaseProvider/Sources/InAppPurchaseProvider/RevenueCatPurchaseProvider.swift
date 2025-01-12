//
//  Created by Tomáš Batěk on 27.10.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import RevenueCat
import Utilities
import UserDefaultsProvider
import KMPSharedDomain

public class RevenueCatPurchaseProvider {
    
    private let revenueCatApiKey = "appl_LqBbtMRhjeASbELUpRKDisMQSeX"
    
    private enum Entitlement {
        case fullAccess
        
        var identifier: String {
            switch self {
            case .fullAccess: "Full Access"
            }
        }
    }
    
    private let userDefaults: UserDefaultsProvider
    
    private var didInit = false
    
    public init(
        userDefaults: UserDefaultsProvider
    ) {
        self.userDefaults = userDefaults
        
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
    
    public func __hasFullAccess() async throws -> Result<KotlinBoolean> {
        let info = try await Purchases.shared.customerInfo()
        
        return ResultSuccess(data: KotlinBoolean(
            bool: info.entitlements[Entitlement.fullAccess.identifier]?.isActive ?? false
        ))
    }
    
    public func __readPackages() async throws -> Result<NSArray> {
        guard let packages = try await Purchases.shared.offerings().current?.availablePackages else {
            return ResultError(error: PurchaseError.NoProducts())
        }
        
        return ResultSuccess(
            data: try packages.map { try $0.toDomain() } as NSArray
        )
    }
    
    public func __purchasePackage(packageId: String) async throws -> Result<KotlinUnit> {
        guard let package = try await Purchases
            .shared
            .offerings()
            .current?
            .availablePackages
            .first(where: { $0.identifier == packageId })
        else {
            return ResultError(error: PurchaseError.PackageNotFound(packageId: packageId))
        }
        
        _ = try await Purchases.shared.purchase(package: package)
        return ResultSuccess(data: KotlinUnit())
    }
    
    public func __readIsPackageEligibleForIntroductoryDiscount(
        packageId: String
    ) async throws -> Result<KotlinBoolean> {
        guard let package = try await Purchases
            .shared
            .offerings()
            .current?
            .availablePackages
            .first(where: { $0.identifier == packageId })
        else {
            return ResultError(error: PurchaseError.PackageNotFound(packageId: packageId))
        }
        
        let eligible = await Purchases
            .shared
            .checkTrialOrIntroDiscountEligibility(packages: [package])
            .first?
            .value
            .status == .eligible
        
        return ResultSuccess(data: KotlinBoolean(bool: eligible))
    }
    
    public func __restorePurchases() async throws -> Result<KotlinUnit> {
        _ = try await Purchases.shared.restorePurchases()
        return ResultSuccess(data: KotlinUnit())
    }
    
    public func __readAlphaHasFullAccess() async throws -> Result<KotlinBoolean> {
        guard let value = try? userDefaults.read(.alphaHasFullAccess) as Bool? else {
            return ResultSuccess(data: KotlinBoolean(bool: false))
        }
        
        return ResultSuccess(data: KotlinBoolean(bool: value))
    }
    
    public func __setAlphaHasFullAccess(hasFullAccess: Bool) async throws -> Result<KotlinUnit> {
        try userDefaults.update(.alphaHasFullAccess, value: hasFullAccess)
        return ResultSuccess(data: KotlinUnit())
    }
    
}
