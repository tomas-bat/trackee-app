package app.trackee.backend.presentation.model.client

import app.trackee.backend.domain.model.client.NewClientResponse
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClientResponseDto(
    @SerialName("client_id") val clientId: String
)

internal fun NewClientResponse.toDto() = NewClientResponseDto(
    clientId = clientId
)