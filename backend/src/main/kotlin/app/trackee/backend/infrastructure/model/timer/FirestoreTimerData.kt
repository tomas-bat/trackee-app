package app.trackee.backend.infrastructure.model.timer

import app.trackee.backend.domain.model.timer.TimerData
import app.trackee.backend.domain.model.timer.TimerStatus
import com.google.cloud.Timestamp
import com.google.cloud.firestore.annotation.PropertyName
import kotlinx.datetime.toKotlinInstant
import kotlinx.serialization.Contextual

internal data class FirestoreTimerData(
    val status: String = "",
    val description: String? = null,

    @get:PropertyName("client_id")
    @set:PropertyName("client_id")
    var clientId: String? = null,

    @get:PropertyName("project_id")
    @set:PropertyName("project_id")
    var projectId: String? = null,

    @Contextual
    @get:PropertyName("started_at")
    @set:PropertyName("started_at")
    var startedAt: Timestamp? = null,
)

internal fun FirestoreTimerData.toDomain() = TimerData(
    status = TimerStatus.entries.firstOrNull { it.rawValue == status } ?: TimerStatus.Off,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt?.toDate()?.toInstant()?.toKotlinInstant(),
)