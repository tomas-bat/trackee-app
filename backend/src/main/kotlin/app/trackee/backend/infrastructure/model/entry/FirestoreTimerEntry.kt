package app.trackee.backend.infrastructure.model.entry

import app.trackee.backend.domain.model.entry.TimerEntry
import com.google.cloud.Timestamp
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreTimerEntry(
    val id: String = "",
    val project_id: String = "",
    val description: String? = null,
    @Contextual
    val started_at: Timestamp = Timestamp.now(),
    @Contextual
    val ended_at: Timestamp = Timestamp.now()
)

internal fun FirestoreTimerEntry.toDomain() = TimerEntry(
    id = id,
    projectId = project_id,
    description = description,
    startedAt = started_at.toDate().toInstant().toKotlinInstant(),
    endedAt = ended_at.toDate().toInstant().toKotlinInstant(),
)