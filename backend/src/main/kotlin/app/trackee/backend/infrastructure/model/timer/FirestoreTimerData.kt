package app.trackee.backend.infrastructure.model.timer

import app.trackee.backend.domain.model.timer.TimerData
import app.trackee.backend.domain.model.timer.TimerStatus
import com.google.cloud.Timestamp
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
data class FirestoreTimerData(
    val status: String = "",
    val projectId: String? = null,
    val description: String? = null,
    @Contextual
    val startedAt: Timestamp? = null,
)

fun FirestoreTimerData.toDomain() = TimerData(
    status = TimerStatus.Off,
    projectId = projectId,
    description = description,
    startedAt = startedAt?.toDate()?.toInstant()?.toKotlinInstant(),
)