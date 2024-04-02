package app.trackee.backend.presentation.model.client

import app.trackee.backend.domain.model.client.NewClient
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClientDto(
    val name: String
)

internal fun NewClientDto.toDomain() = NewClient(
    name = name
)