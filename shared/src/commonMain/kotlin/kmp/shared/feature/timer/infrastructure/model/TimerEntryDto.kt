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
    @SerialName("ended_at") val endedAt: String,
    @SerialName("clockify_entry_id") val clockifyEntryId: String?,
    @SerialName("clockify_workspace_id") val clockifyWorkspaceId: String?
)

fun TimerEntryDto.toDomain() = TimerEntry(
    id = id,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toInstant(),
    endedAt = endedAt.toInstant(),
    clockifyEntryId = clockifyEntryId,
    clockifyWorkspaceId = clockifyWorkspaceId
)

fun TimerEntry.toDto() = TimerEntryDto(
    id = id,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toString(),
    endedAt = endedAt.toString(),
    clockifyEntryId = clockifyEntryId,
    clockifyWorkspaceId = clockifyWorkspaceId
)