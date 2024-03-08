package kmp.shared.feature.auth.domain.repository

import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.model.LoginResponse

internal interface AuthRepository {
    suspend fun loginWithProvider(
        providerType: ExternalLoginType,
        retryIfCancelled: Boolean
    ): LoginResponse

    suspend fun loginWithCredentials(
        username: String,
        password: String
    ): LoginResponse
}