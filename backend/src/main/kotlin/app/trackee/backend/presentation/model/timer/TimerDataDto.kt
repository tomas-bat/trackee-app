package app.trackee.backend.presentation.model.timer

import app.trackee.backend.domain.model.timer.TimerData
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerDataDto(
    val status: String,
    val projectId: String?,
    val description: String?,
    val startedAt: String?
)

internal fun TimerData.toDto() = TimerDataDto(
    status = status.toString(),
    projectId = projectId,
    description = description,
    startedAt = startedAt?.toString()
)