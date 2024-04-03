package kmp.shared.feature.profile.infrastructure.model

import kmp.shared.feature.profile.domain.model.NewClientResponse
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClientResponseDto(
    @SerialName("client_id") val clientId: String
)

internal fun NewClientResponseDto.toDomain() = NewClientResponse(
    clientId = clientId
)