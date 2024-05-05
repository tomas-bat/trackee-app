package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyProject
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyProject(
    val id: String,
    val name: String,
    val clientName: String
)

internal fun RawClockifyProject.toDomain() = ClockifyProject(
    id = id,
    name = name,
    clientName = clientName
)

internal fun ClockifyProject.toRaw() = RawClockifyProject(
    id = id,
    name = name,
    clientName = clientName
)
