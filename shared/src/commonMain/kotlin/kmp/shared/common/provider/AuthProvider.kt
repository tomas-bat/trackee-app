package kmp.shared.common.provider

import kmp.shared.base.Result
import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.model.ExternalProviderCredential
import kmp.shared.feature.auth.domain.model.LoginResponse

interface AuthProvider {
    suspend fun signIn(
        providerType: ExternalLoginType,
        providerCredential: ExternalProviderCredential
    ): Result<LoginResponse>

    suspend fun signIn(
        email: String,
        password: String
    ): Result<LoginResponse>

    suspend fun createUser(
        email: String,
        password: String
    ): Result<LoginResponse>

    suspend fun readAccessToken(): Result<String>

    suspend fun readCurrentUserUid(): Result<String>

    suspend fun logout(): Result<Unit>

    suspend fun readUserEmail(): Result<String>
}