package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerEntry
import kotlinx.datetime.toInstant
import kotlinx.serialization.Serializable

@Serializable
data class TimerEntryDto(
    val id: String,
    val projectId: String,
    val description: String?,
    val startedAt: String,
    val endedAt: String
)

fun TimerEntryDto.toDomain() = TimerEntry(
    id = id,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toInstant(),
    endedAt = endedAt.toInstant(),
)