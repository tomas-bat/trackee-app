package kmp.shared.common.provider

import kmp.shared.base.Result
import kmp.shared.feature.auth.domain.model.ExternalProviderCredential

interface AppleSignInProvider {
    suspend fun readAppleCredential(): Result<ExternalProviderCredential>
}