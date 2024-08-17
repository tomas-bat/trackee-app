package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.presentation.model.client.ClientDto
import app.trackee.backend.presentation.model.client.toDomain
import app.trackee.backend.presentation.model.client.toDto
import app.trackee.backend.presentation.model.project.ProjectDto
import app.trackee.backend.presentation.model.project.toDomain
import app.trackee.backend.presentation.model.project.toDto
import kotlinx.datetime.toInstant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerEntryPreviewDto(
    val id: String,
    val project: ProjectDto,
    val client: ClientDto,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String,
    @SerialName("clockify_id") val clockifyId: String?,
    @SerialName("clockify_workspace_id") val clockifyWorkspaceId: String?,
)

internal fun TimerEntryPreview.toDto(): TimerEntryPreviewDto =
    TimerEntryPreviewDto(
        id = id,
        project = project.toDto(),
        client = client.toDto(),
        description = description,
        startedAt = startedAt.toString(),
        endedAt = endedAt.toString(),
        clockifyId = clockifyEntryId,
        clockifyWorkspaceId = clockifyWorkspaceId
    )

internal fun TimerEntryPreviewDto.toDomain(): TimerEntryPreview =
    TimerEntryPreview(
        id = id,
        project = project.toDomain(),
        client = client.toDomain(),
        description = description,
        startedAt = startedAt.toInstant(),
        endedAt = endedAt.toInstant(),
        clockifyEntryId = clockifyId,
        clockifyWorkspaceId = clockifyWorkspaceId
    )
