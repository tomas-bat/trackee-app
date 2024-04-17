package kmp.shared.feature.intent.infrastructure.model

import kmp.shared.feature.intent.domain.model.StartTimerBody
import kotlinx.serialization.Serializable

@Serializable
internal data class StartTimerBodyDto(
    val clientId: String?,
    val projectId: String?,
    val description: String?
)

internal fun StartTimerBody.toDto() = StartTimerBodyDto(
    clientId = clientId,
    projectId = projectId,
    description = description
)