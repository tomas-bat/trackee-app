package app.trackee.backend.domain.model.entry

import kotlinx.datetime.Instant

data class TimerEntry(
    val id: String,
    val clientId: String,
    val projectId: String,
    val description: String?,
    val startedAt: Instant,
    val endedAt: Instant,
    val clockifyEntryId: String?,
    val clockifyWorkspaceId: String?
)

fun TimerEntry.length() = endedAt - startedAt