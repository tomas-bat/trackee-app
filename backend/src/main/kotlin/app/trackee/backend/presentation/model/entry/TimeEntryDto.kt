package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.TimeEntry
import kotlinx.serialization.Serializable

@Serializable
internal data class TimeEntryDto(
    val id: String,
    val projectId: String,
    val description: String?,
    val startedAt: String,
    val endedAt: String
)

internal fun TimeEntry.toDto() = TimeEntryDto(
    id = id,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toString(),
    endedAt = endedAt.toString()
)