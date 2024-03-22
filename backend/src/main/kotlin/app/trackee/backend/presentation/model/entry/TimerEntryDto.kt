package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.TimerEntry
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerEntryDto(
    val id: String,
    val project_id: String,
    val description: String?,
    val started_at: String,
    val ended_at: String
)

internal fun TimerEntry.toDto() = TimerEntryDto(
    id = id,
    project_id = projectId,
    description = description,
    started_at = startedAt.toString(),
    ended_at = endedAt.toString()
)