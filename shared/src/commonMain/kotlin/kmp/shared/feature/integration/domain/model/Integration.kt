package kmp.shared.feature.integration.domain.model

data class Integration(
    val id: String,
    val label: String,
    val type: IntegrationType,
    val apiKey: String?
)
