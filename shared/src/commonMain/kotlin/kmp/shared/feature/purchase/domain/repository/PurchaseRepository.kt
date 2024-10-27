package kmp.shared.feature.purchase.domain.repository

import kmp.shared.base.Result

internal interface PurchaseRepository {
    suspend fun readHasFullAccess(): Result<Boolean>
}