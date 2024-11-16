package kmp.shared.common.provider

import kmp.shared.base.Result
import kmp.shared.feature.purchase.domain.model.PurchasePackage

interface InAppPurchaseProvider {
    suspend fun logIn(userId: String): Result<Unit>
    suspend fun logOut(): Result<Unit>
    suspend fun hasFullAccess(): Result<Boolean>
    suspend fun readPackages(): Result<List<PurchasePackage>>
    suspend fun purchasePackage(packageId: String): Result<Unit>

    suspend fun readIsPackageEligibleForIntroductoryDiscount(
        packageId: String
    ): Result<Boolean>
}