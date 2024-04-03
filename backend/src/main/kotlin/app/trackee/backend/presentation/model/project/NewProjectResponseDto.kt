package app.trackee.backend.presentation.model.project

import app.trackee.backend.domain.model.project.NewProjectResponse
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewProjectResponseDto(
    @SerialName("client_id") val clientId: String,
    @SerialName("project_id") val projectId: String
)

internal fun NewProjectResponse.toDto() = NewProjectResponseDto(
    clientId = clientId,
    projectId = projectId
)