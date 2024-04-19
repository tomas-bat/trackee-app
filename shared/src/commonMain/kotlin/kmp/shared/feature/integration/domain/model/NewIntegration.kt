package kmp.shared.feature.integration.domain.model

data class NewIntegration(
    val label: String,
    val type: IntegrationType,
    val apiKey: String?
)