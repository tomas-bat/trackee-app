package app.trackee.backend.presentation.model.project

import app.trackee.backend.domain.model.project.Project
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ProjectDto(
    val id: String,
    @SerialName("client_id") val clientId: String,
    val type: String?,
    val name: String
)

internal fun Project.toDto() = ProjectDto(
    id = id,
    clientId = clientId,
    type = type?.rawValue,
    name = name
)