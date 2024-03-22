package app.trackee.backend.infrastructure.model.entry

import app.trackee.backend.domain.model.entry.TimerEntry
import com.google.cloud.Timestamp
import com.google.cloud.firestore.annotation.PropertyName
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual

internal data class FirestoreTimerEntry(
    val id: String = "",
    val description: String? = null,

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
    var endedAt: Timestamp = Timestamp.now()
)

internal fun FirestoreTimerEntry.toDomain() = TimerEntry(
    id = id,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toDate().toInstant().toKotlinInstant(),
    endedAt = endedAt.toDate().toInstant().toKotlinInstant(),
)