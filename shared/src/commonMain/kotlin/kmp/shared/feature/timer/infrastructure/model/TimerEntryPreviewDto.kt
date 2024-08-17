package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerEntryPreview
import kotlinx.datetime.toInstant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TimerEntryPreviewDto(
    val id: String,
    val project: ProjectDto,
    val client: ClientDto,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String,
    @SerialName("clockify_entry_id") val clockifyEntryId: String?,
    @SerialName("clockify_workspace_id") val clockifyWorkspaceId: String?
)

fun TimerEntryPreviewDto.toDomain(): TimerEntryPreview =
    TimerEntryPreview(
        id = id,
        project = project.toDomain(),
        client = client.toDomain(),
        description = description,
        startedAt = startedAt.toInstant(),
        endedAt = endedAt.toInstant(),
        clockifyEntryId = clockifyEntryId,
        clockifyWorkspaceId = clockifyWorkspaceId
    )