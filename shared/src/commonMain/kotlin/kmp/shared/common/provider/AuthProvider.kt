package kmp.shared.common.provider

import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.model.ExternalProviderCredential
import kmp.shared.feature.auth.domain.model.LoginResponse

interface AuthProvider {
    suspend fun signIn(
        providerType: ExternalLoginType,
        providerCredential: ExternalProviderCredential
    ): LoginResponse
}