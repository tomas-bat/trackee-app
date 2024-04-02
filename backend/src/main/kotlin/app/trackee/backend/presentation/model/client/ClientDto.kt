package app.trackee.backend.presentation.model.client

import app.trackee.backend.domain.model.client.Client
import kotlinx.serialization.Serializable

@Serializable
internal data class ClientDto(
    val id: String,
    val name: String,
)

internal fun Client.toDto() = ClientDto(
    id = id,
    name = name
)

internal fun ClientDto.toDomain() = Client(
    id = id,
    name = name
)