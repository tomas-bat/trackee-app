package app.trackee.backend.presentation.model.integration

import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.IntegrationType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class IntegrationDto(
    val id: String,
    val label: String,
    val type: String,
    @SerialName("api_key") val apiKey: String?
)

internal fun Integration.toDto() = IntegrationDto(
    id = id,
    label = label,
    type = type.rawValue,
    apiKey = apiKey
)

internal fun IntegrationDto.toDomain() = Integration(
    id = id,
    label = label,
    type = IntegrationType.entries.first { it.rawValue == type },
    apiKey = apiKey
)
