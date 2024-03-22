package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.Project
import kmp.shared.feature.timer.domain.model.ProjectType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ProjectDto(
    val id: String,
    @SerialName("client_id") val clientId: String,
    val type: String?,
    val name: String
)

fun ProjectDto.toDomain() = Project(
    id = id,
    clientId = clientId,
    type = ProjectType.entries.firstOrNull { it.rawValue == type },
    name = name
)