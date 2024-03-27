package app.trackee.backend.presentation.model.timer

import app.trackee.backend.domain.model.timer.TimerDataPreview
import app.trackee.backend.presentation.model.client.ClientDto
import app.trackee.backend.presentation.model.client.toDto
import app.trackee.backend.presentation.model.project.ProjectDto
import app.trackee.backend.presentation.model.project.toDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerDataPreviewDto(
    val status: String,
    val client: ClientDto?,
    val project: ProjectDto?,
    val description: String?,
    @SerialName("started_at") val startedAt: String?,
    @SerialName("available_projects") val availableProjects: List<ProjectDto>
)

internal fun TimerDataPreview.toDto(): TimerDataPreviewDto =
    TimerDataPreviewDto(
        status = status.rawValue,
        client = client?.toDto(),
        project = project?.toDto(),
        description = description,
        startedAt = startedAt?.toString(),
        availableProjects = availableProjects.map { it.toDto() }
    )