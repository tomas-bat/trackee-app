package app.trackee.backend.presentation.model.integration

import app.trackee.backend.domain.model.integration.IntegrationType
import app.trackee.backend.domain.model.integration.NewIntegration
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class NewIntegrationDto(
    val label: String,
    val type: String,
    @SerialName("api_key") val apiKey: String?
)

internal fun NewIntegrationDto.toDomain() = NewIntegration(
    label = label,
    type = IntegrationType.entries.first { it.rawValue == type },
    apiKey = apiKey
)
