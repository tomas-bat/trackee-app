package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.TimerEntry
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerEntryDto(
    val id: String,
    val projectId: String,
    val description: String?,
    val startedAt: String,
    val endedAt: String
)

internal fun TimerEntry.toDto() = TimerEntryDto(
    id = id,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toString(),
    endedAt = endedAt.toString()
)