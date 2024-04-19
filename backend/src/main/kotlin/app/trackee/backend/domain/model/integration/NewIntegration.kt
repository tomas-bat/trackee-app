package app.trackee.backend.domain.model.integration

data class NewIntegration(
    val label: String,
    val type: IntegrationType,
    val apiKey: String?
)
