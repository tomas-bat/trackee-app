package app.trackee.backend.infrastructure.model.entry

import app.trackee.backend.config.util.toTimestamp
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.entry.TimerEntry
import com.google.cloud.Timestamp
import com.google.cloud.firestore.annotation.PropertyName
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual

internal data class FirestoreTimerEntry(
    val id: String = "",
    val description: String? = null,

    @get:PropertyName("client_id")
    @set:PropertyName("client_id")
    var clientId: String = "",

    @get:PropertyName("project_id")
    @set:PropertyName("project_id")
    var projectId: String = "",

    @Contextual
    @get:PropertyName("started_at")
    @set:PropertyName("started_at")
    var startedAt: Timestamp = Timestamp.now(),

    @Contextual
    @get:PropertyName("ended_at")
    @set:PropertyName("ended_at")
    var endedAt: Timestamp = Timestamp.now(),

    @get:PropertyName("clockify_id")
    @set:PropertyName("clockify_id")
    var clockifyId: String?,

    @get:PropertyName("clockify_workspace_id")
    @set:PropertyName("clockify_workspace_id")
    var clockifyWorkspaceId: String?
)

internal fun FirestoreTimerEntry.toDomain() = TimerEntry(
    id = id,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toDate().toInstant().toKotlinInstant(),
    endedAt = endedAt.toDate().toInstant().toKotlinInstant(),
    clockifyEntryId = clockifyId,
    clockifyWorkspaceId = clockifyWorkspaceId
)

internal fun NewTimerEntry.toFirestoreEntry(id: String) = FirestoreTimerEntry(
    id = id,
    description = description,
    clientId = clientId,
    projectId = projectId,
    startedAt = startedAt.toTimestamp(),
    endedAt = endedAt.toTimestamp(),
    clockifyId = null,
    clockifyWorkspaceId = null
)

internal fun TimerEntry.toFirestoreEntry() = FirestoreTimerEntry(
    id = id,
    description = description,
    clientId = clientId,
    projectId = projectId,
    startedAt = startedAt.toTimestamp(),
    endedAt = endedAt.toTimestamp(),
    clockifyId = clockifyEntryId,
    clockifyWorkspaceId = clockifyWorkspaceId
)