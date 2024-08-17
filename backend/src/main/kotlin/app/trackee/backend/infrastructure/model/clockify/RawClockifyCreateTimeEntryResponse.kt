package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyCreateTimeEntryResponse
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyCreateTimeEntryResponse(
    val id: String
)

internal fun RawClockifyCreateTimeEntryResponse.toDomain() = ClockifyCreateTimeEntryResponse(
    id = id
)
