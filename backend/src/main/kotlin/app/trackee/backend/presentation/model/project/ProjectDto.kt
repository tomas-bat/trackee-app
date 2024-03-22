package app.trackee.backend.presentation.model.project

import app.trackee.backend.domain.model.project.Project
import kotlinx.serialization.Serializable

@Serializable
internal data class ProjectDto(
    val id: String,
    val client_id: String,
    val type: String?,
    val name: String
)

internal fun Project.toDto() = ProjectDto(
    id = id,
    client_id = clientId,
    type = type?.rawValue,
    name = name
)