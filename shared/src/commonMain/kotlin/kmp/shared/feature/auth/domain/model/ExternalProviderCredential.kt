package kmp.shared.feature.auth.domain.model

data class ExternalProviderCredential(
    val idToken: String,
    val accessToken: String?,
    val rawNonce: String?,
    val hashedNonce: String?
)