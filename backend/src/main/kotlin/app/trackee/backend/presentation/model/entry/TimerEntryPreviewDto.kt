package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.presentation.model.client.ClientDto
import app.trackee.backend.presentation.model.client.toDto
import app.trackee.backend.presentation.model.project.ProjectDto
import app.trackee.backend.presentation.model.project.toDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerEntryPreviewDto(
    val id: String,
    val project: ProjectDto,
    val client: ClientDto,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String
)

internal fun TimerEntryPreview.toDto(): TimerEntryPreviewDto =
    TimerEntryPreviewDto(
        id = id,
        project = project.toDto(),
        client = client.toDto(),
        description = description,
        startedAt = startedAt.toString(),
        endedAt = endedAt.toString()
    )
