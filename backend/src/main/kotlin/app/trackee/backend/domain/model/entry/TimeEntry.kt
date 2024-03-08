package app.trackee.backend.domain.model.entry

import kotlinx.datetime.LocalDate

data class TimeEntry(
    val id: String,
    val projectId: String?,
    val description: String?,
    val startedAt: LocalDate?,
    val endedAt: LocalDate?
)