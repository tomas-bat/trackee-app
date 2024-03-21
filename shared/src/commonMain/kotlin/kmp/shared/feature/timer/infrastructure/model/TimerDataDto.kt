package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerData
import kmp.shared.feature.timer.domain.model.TimerStatus
import kotlinx.datetime.toInstant
import kotlinx.serialization.Serializable

@Serializable
data class TimerDataDto(
    val status: String = "",
    val projectId: String? = null,
    val description: String? = null,
    val startedAt: String? = null,
)

fun TimerDataDto.toDomain() = TimerData(
    status = TimerStatus.Off,
    projectId = projectId,
    description = description,
    startedAt = startedAt?.toInstant(),
)