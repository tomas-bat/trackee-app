package kmp.shared.feature.auth.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.model.LoginResponse

internal interface AuthRepository {
    suspend fun loginWithProvider(
        providerType: ExternalLoginType,
        retryIfCancelled: Boolean
    ): Result<LoginResponse>

    suspend fun loginWithCredentials(
        username: String,
        password: String
    ): Result<LoginResponse>
}