package app.trackee.backend.presentation.model.project

import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.ProjectColor
import app.trackee.backend.domain.model.project.ProjectType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewProjectDto(
    @SerialName("client_id") val clientId: String,
    val type: String?,
    val name: String,
    val color: String?
)

internal fun NewProjectDto.toDomain() = NewProject(
    clientId = clientId,
    type = ProjectType.entries.firstOrNull { it.rawValue == type },
    name = name,
    color = ProjectColor.entries.firstOrNull { it.rawValue == color }
)