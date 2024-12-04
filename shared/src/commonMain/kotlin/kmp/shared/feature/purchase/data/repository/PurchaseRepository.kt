package kmp.shared.feature.purchase.data.repository

import kmp.shared.base.Result
import kmp.shared.common.provider.InAppPurchaseProvider
import kmp.shared.feature.purchase.domain.model.PurchasePackage
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

internal class PurchaseRepositoryImpl(
    private val provider: InAppPurchaseProvider
) : PurchaseRepository {
    override suspend fun readHasFullAccess(): Result<Boolean> =
        provider.hasFullAccess()

    override suspend fun readPackages(): Result<List<PurchasePackage>> =
        provider.readPackages()

    override suspend fun purchasePackage(packageId: String) =
        provider.purchasePackage(packageId)

    override suspend fun restorePurchases(): Result<Unit> =
        provider.restorePurchases()

    override suspend fun readIsPackageEligibleForIntroductoryDiscount(
        packageId: String
    ): Result<Boolean> =
        provider.readIsPackageEligibleForIntroductoryDiscount(packageId)
}