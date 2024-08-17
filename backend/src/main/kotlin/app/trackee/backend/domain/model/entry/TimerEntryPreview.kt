package app.trackee.backend.domain.model.entry

import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.project.Project
import kotlinx.datetime.Instant

data class TimerEntryPreview(
    val id: String,
    val project: Project,
    val client: Client,
    val description: String?,
    val startedAt: Instant,
    val endedAt: Instant,
    val clockifyEntryId: String?,
    val clockifyWorkspaceId: String?
)

fun TimerEntryPreview.toTimerEntry(): TimerEntry = TimerEntry(
    id = id,
    clientId = client.id,
    projectId = project.id,
    description = description,
    startedAt = startedAt,
    endedAt = endedAt,
    clockifyEntryId = clockifyEntryId,
    clockifyWorkspaceId = clockifyWorkspaceId
)