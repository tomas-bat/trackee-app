package app.trackee.backend.domain.model.entry

import kotlinx.datetime.Instant

data class NewTimerEntry(
    val clientId: String,
    val projectId: String,
    val description: String?,
    val startedAt: Instant,
    val endedAt: Instant
)