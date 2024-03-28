package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.NewTimerEntry
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class NewTimerEntryDto(
    @SerialName("client_id") val clientId: String,
    @SerialName("project_id") val projectId: String,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String
)

fun NewTimerEntry.toDto() = NewTimerEntryDto(
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toString(),
    endedAt = endedAt.toString()
)

