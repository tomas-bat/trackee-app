package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyUpdateTimeEntryResponse
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyUpdateTimeEntryResponse(
    val id: String,
    val workspaceId: String
)

internal fun RawClockifyUpdateTimeEntryResponse.toDomain() = ClockifyUpdateTimeEntryResponse(
    id = id,
    workspaceId = workspaceId
)
