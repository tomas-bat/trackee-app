package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.Client
import kotlinx.serialization.Serializable

@Serializable
data class ClientDto(
    val id: String,
    val name: String
)

fun ClientDto.toDomain(): Client = Client(
    id = id,
    name = name
)

fun Client.toDto() = ClientDto(
    id = id,
    name = name
)