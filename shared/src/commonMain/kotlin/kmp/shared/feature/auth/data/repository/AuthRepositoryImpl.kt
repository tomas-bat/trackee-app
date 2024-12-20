package kmp.shared.feature.auth.data.repository

import kmp.shared.base.Result
import kmp.shared.common.provider.AppleSignInProvider
import kmp.shared.common.provider.AuthProvider
import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.model.ExternalLoginType.Apple
import kmp.shared.feature.auth.domain.model.LoginResponse
import kmp.shared.feature.auth.domain.repository.AuthRepository

internal class AuthRepositoryImpl(
    private val appleSignInProvider: AppleSignInProvider,
    private val authProvider: AuthProvider
) : AuthRepository {

    override suspend fun loginWithProvider(
        providerType: ExternalLoginType,
        retryIfCancelled: Boolean
    ): Result<LoginResponse> {
        val providerCredentialResult = when (providerType) {
            Apple -> appleSignInProvider.readAppleCredential()
        }

        val providerCredential = when (providerCredentialResult) {
            is Result.Success -> providerCredentialResult.data
            is Result.Error -> return Result.Error(providerCredentialResult.error)
        }

        return authProvider.signIn(
            providerType = providerType,
            providerCredential = providerCredential
        )
    }

    override suspend fun loginWithCredentials(
        username: String,
        password: String
    ): Result<LoginResponse> =
        authProvider.signIn(username, password)

    override suspend fun createUser(username: String, password: String): Result<LoginResponse> =
        authProvider.createUser(username, password)

    override suspend fun readAccessToken(): Result<String> =
        authProvider.readAccessToken()

    override suspend fun readCurrentUserUid(): Result<String> =
        authProvider.readCurrentUserUid()

    override suspend fun logout(): Result<Unit> =
        authProvider.logout()
}