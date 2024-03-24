package app.trackee.backend.presentation.model.timer

import app.trackee.backend.domain.model.timer.TimerData
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerDataDto(
    val status: String,
    @SerialName("client_id") val clientId: String?,
    @SerialName("project_id") val projectId: String?,
    val description: String?,
    @SerialName("started_at") val startedAt: String?
)

internal fun TimerData.toDto() = TimerDataDto(
    status = status.toString(),
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt?.toString()
)