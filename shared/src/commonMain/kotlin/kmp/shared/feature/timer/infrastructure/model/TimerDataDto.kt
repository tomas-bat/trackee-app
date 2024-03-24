package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerData
import kmp.shared.feature.timer.domain.model.TimerStatus
import kotlinx.datetime.toInstant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TimerDataDto(
    val status: String,
    @SerialName("client_id") val clientId: String?,
    @SerialName("project_id") val projectId: String?,
    val description: String?,
    @SerialName("started_at") val startedAt: String?
)

fun TimerDataDto.toDomain() = TimerData(
    status = TimerStatus.Off,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt?.toInstant(),
)