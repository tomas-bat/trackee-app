package app.trackee.backend.presentation.model.client

import app.trackee.backend.presentation.model.project.ProjectDto
import kotlinx.serialization.Serializable

@Serializable
internal data class ClientDto(
    val id: String,
    val name: String,
    val projects: List<ProjectDto>
)