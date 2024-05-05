package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyWorkspace
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyWorkspace(
    val id: String,
    val name: String
)

internal fun ClockifyWorkspace.toRaw() = RawClockifyWorkspace(
    id = id,
    name = name
)

internal fun RawClockifyWorkspace.toDomain() = ClockifyWorkspace(
    id = id,
    name = name
)
