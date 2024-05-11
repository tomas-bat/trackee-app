package app.trackee.backend.presentation.model.project

import app.trackee.backend.domain.model.project.IdentifiableProject
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class IdentifiableProjectDto(
    @SerialName("project_id") val projectId: String,
    @SerialName("client_id") val clientId: String
)

internal fun IdentifiableProjectDto.toDomain() = IdentifiableProject(
    projectId = projectId,
    clientId = clientId
)

internal fun IdentifiableProject.toDto() = IdentifiableProjectDto(
    projectId = projectId,
    clientId = clientId
)
