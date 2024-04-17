package app.trackee.backend.presentation.model.timer

import app.trackee.backend.domain.model.timer.StartTimerBody
import kotlinx.serialization.Serializable

@Serializable
internal data class StartTimerBodyDto(
    val clientId: String?,
    val projectId: String?,
    val description: String?
)

internal fun StartTimerBodyDto.toDomain() = StartTimerBody(
    clientId = clientId,
    projectId = projectId,
    description = description
)