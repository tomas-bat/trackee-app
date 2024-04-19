package kmp.shared.feature.integration.infrastructure.model

import kmp.shared.feature.integration.domain.model.IntegrationType
import kmp.shared.feature.integration.domain.model.NewIntegration
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

internal fun NewIntegration.toDto() = NewIntegrationDto(
    label = label,
    type = type.rawValue,
    apiKey = apiKey
)
