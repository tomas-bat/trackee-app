package kmp.shared.feature.profile.infrastructure.model

import kmp.shared.feature.profile.domain.model.NewProjectResponse
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewProjectResponseDto(
    @SerialName("client_id") val clientId: String,
    @SerialName("project_id") val projectId: String
)

internal fun NewProjectResponseDto.toDomain() = NewProjectResponse(
    clientId = clientId,
    projectId = projectId
)