package app.trackee.backend.infrastructure.model.entry

import app.trackee.backend.domain.model.entry.TimerEntry
import com.google.cloud.Timestamp
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreTimerEntry(
    val id: String = "",
    val projectId: String = "",
    val description: String? = null,
    @Contextual
    val startedAt: Timestamp = Timestamp.now(),
    @Contextual
    val endedAt: Timestamp = Timestamp.now()
)

internal fun FirestoreTimerEntry.toDomain() = TimerEntry(
    id = id,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toDate().toInstant().toKotlinInstant(),
    endedAt = endedAt.toDate().toInstant().toKotlinInstant(),
)