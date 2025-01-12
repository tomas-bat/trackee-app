package kmp.shared.feature.purchase.data.repository

import kmp.shared.base.Result
import kmp.shared.base.util.extension.toSuccessResult
import kmp.shared.common.provider.AppEnvironment
import kmp.shared.common.provider.AppInfoProvider
import kmp.shared.common.provider.InAppPurchaseProvider
import kmp.shared.configuration.domain.configuration
import kmp.shared.feature.purchase.domain.model.PurchasePackage
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

internal class PurchaseRepositoryImpl(
    private val provider: InAppPurchaseProvider,
    private val appInfoProvider: AppInfoProvider
) : PurchaseRepository {
    override suspend fun readHasFullAccess(): Result<Boolean> {
        if (appInfoProvider.environment == AppEnvironment.Alpha) {
            val alphaHasFullAccess = when (val result = provider.readAlphaHasFullAccess()) {
                is Result.Success -> result.data
                is Result.Error -> false
            }

            if (alphaHasFullAccess) {
                return Result.Success(true)
            }
        }

        return provider.hasFullAccess()
    }

    override suspend fun readPackages(): Result<List<PurchasePackage>> =
        provider.readPackages()

    override suspend fun purchasePackage(packageId: String) =
        provider.purchasePackage(packageId)

    override suspend fun restorePurchases(): Result<Unit> =
        provider.restorePurchases()

    override suspend fun setAlphaHasFullAccess(hasFullAccess: Boolean): Result<Unit> =
        provider.setAlphaHasFullAccess(hasFullAccess)

    override suspend fun readAlphaHasFullAccess(): Result<Boolean> =
        provider.readAlphaHasFullAccess()

    override fun getPrivacyPolicyUrl(): Result<String> =
        "https://${appInfoProvider.environment.configuration.host}/static/privacy-policy.html"
            .toSuccessResult()

    override fun getTermsAndConditionsUrl(): Result<String> =
        "https://${appInfoProvider.environment.configuration.host}/static/terms-and-conditions.html"
            .toSuccessResult()

    override suspend fun readIsPackageEligibleForIntroductoryDiscount(
        packageId: String
    ): Result<Boolean> =
        provider.readIsPackageEligibleForIntroductoryDiscount(packageId)
}