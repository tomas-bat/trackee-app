package kmp.shared.feature.purchase.data.repository

import kmp.shared.base.Result
import kmp.shared.common.provider.InAppPurchaseProvider
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

internal class PurchaseRepositoryImpl(
    private val provider: InAppPurchaseProvider
) : PurchaseRepository {
    override suspend fun readHasFullAccess(): Result<Boolean> =
        provider.hasFullAccess()
}