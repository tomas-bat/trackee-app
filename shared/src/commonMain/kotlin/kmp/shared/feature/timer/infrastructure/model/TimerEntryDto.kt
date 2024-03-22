package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerEntry
import kotlinx.datetime.toInstant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TimerEntryDto(
    val id: String,
    @SerialName("client_id") val clientId: String,
    @SerialName("project_id") val projectId: String,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String
)

fun TimerEntryDto.toDomain() = TimerEntry(
    id = id,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toInstant(),
    endedAt = endedAt.toInstant(),
)