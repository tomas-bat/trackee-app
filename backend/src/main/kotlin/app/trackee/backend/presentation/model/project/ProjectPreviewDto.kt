package app.trackee.backend.presentation.model.project

import app.trackee.backend.domain.model.project.ProjectPreview
import app.trackee.backend.presentation.model.client.ClientDto
import app.trackee.backend.presentation.model.client.toDto
import kotlinx.serialization.Serializable

@Serializable
internal data class ProjectPreviewDto(
    val id: String,
    val client: ClientDto,
    val type: String?,
    val name: String
)

internal fun ProjectPreview.toDto(): ProjectPreviewDto =
    ProjectPreviewDto(
        id = id,
        client = client.toDto(),
        type = type?.rawValue,
        name = name
    )