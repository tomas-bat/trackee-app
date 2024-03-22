package app.trackee.backend.infrastructure.model.timer

import app.trackee.backend.domain.model.timer.TimerData
import app.trackee.backend.domain.model.timer.TimerStatus
import com.google.cloud.Timestamp
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreTimerData(
    val status: String = "",
    val project_id: String? = null,
    val description: String? = null,
    @Contextual
    val started_at: Timestamp? = null,
)

internal fun FirestoreTimerData.toDomain() = TimerData(
    status = TimerStatus.entries.firstOrNull { it.rawValue == status } ?: TimerStatus.Off,
    projectId = project_id,
    description = description,
    startedAt = started_at?.toDate()?.toInstant()?.toKotlinInstant(),
)