package app.trackee.backend.domain.model.integration

data class Integration(
    val id: String,
    val label: String,
    val type: IntegrationType,
    val apiKey: String?
)
