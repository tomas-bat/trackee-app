package kmp.shared.common.provider

import kmp.shared.base.Result

interface InAppPurchaseProvider {
    suspend fun logIn(userId: String): Result<Unit>
    suspend fun logOut(): Result<Unit>
    suspend fun hasFullAccess(): Result<Boolean>
}