package kmp.shared.feature.auth.data.repository

import kmp.shared.common.provider.AppleSignInProvider
import kmp.shared.common.provider.AuthProvider
import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.model.LoginResponse
import kmp.shared.feature.auth.domain.repository.AuthRepository

internal class AuthRepositoryImpl(
    private val appleSignInProvider: AppleSignInProvider,
    private val authProvider: AuthProvider
) : AuthRepository {

    override suspend fun loginWithProvider(providerType: ExternalLoginType, retryIfCancelled: Boolean): LoginResponse {
//        TODO("Not yet implemented")
        val providerCredential = when (providerType) {
            ExternalLoginType.Apple -> appleSignInProvider.readAppleCredential()
        }

        return authProvider.signIn(
            providerType = providerType,
            providerCredential = providerCredential
        )
    }

    override suspend fun loginWithCredentials(username: String, password: String): LoginResponse {
        TODO("Not yet implemented")
    }

}