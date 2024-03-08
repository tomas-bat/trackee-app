package app.trackee.backend.infrastructure.model.entry

import app.trackee.backend.domain.model.entry.TimeEntry
import com.google.cloud.Timestamp
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
data class FirestoreTimeEntry(
    val id: String = "",
    val projectId: String = "",
    val description: String? = null,
    @Contextual
    val startedAt: Timestamp = Timestamp.now(),
    @Contextual
    val endedAt: Timestamp = Timestamp.now()
)

fun FirestoreTimeEntry.toDomain() = TimeEntry(
    id = id,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toDate().toInstant().toKotlinInstant(),
    endedAt = endedAt.toDate().toInstant().toKotlinInstant(),
)