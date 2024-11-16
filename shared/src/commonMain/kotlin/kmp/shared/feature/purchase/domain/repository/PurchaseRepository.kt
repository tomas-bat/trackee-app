package kmp.shared.feature.purchase.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.purchase.domain.model.PurchasePackage

internal interface PurchaseRepository {
    suspend fun readHasFullAccess(): Result<Boolean>
    suspend fun readPackages(): Result<List<PurchasePackage>>
    suspend fun purchasePackage(packageId: String): Result<Unit>

    suspend fun readIsPackageEligibleForIntroductoryDiscount(
        packageId: String
    ): Result<Boolean>
}