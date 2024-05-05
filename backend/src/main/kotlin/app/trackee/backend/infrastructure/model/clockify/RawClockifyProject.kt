package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyProject
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyProject(
    val id: String,
    val name: String
)

internal fun RawClockifyProject.toDomain() = ClockifyProject(
    id = id,
    name = name
)

internal fun ClockifyProject.toRaw() = RawClockifyProject(
    id = id,
    name = name
)
