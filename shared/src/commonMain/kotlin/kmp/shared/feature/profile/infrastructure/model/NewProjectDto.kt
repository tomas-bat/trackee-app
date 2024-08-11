package kmp.shared.feature.profile.infrastructure.model

import kmp.shared.feature.profile.domain.model.NewProject
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewProjectDto(
    @SerialName("client_id") val clientId: String,
    val type: String?,
    val name: String,
    val color: String?
)

internal fun NewProject.toDto() = NewProjectDto(
    clientId = clientId,
    type = type?.rawValue,
    name = name,
    color = color?.rawValue
)