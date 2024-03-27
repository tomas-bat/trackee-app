package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.ProjectPreview
import kmp.shared.feature.timer.domain.model.ProjectType
import kotlinx.serialization.Serializable

@Serializable
data class ProjectPreviewDto(
    val id: String,
    val client: ClientDto,
    val type: String?,
    val name: String
)

fun ProjectPreviewDto.toDomain(): ProjectPreview =
    ProjectPreview(
        id = id,
        client = client.toDomain(),
        type = ProjectType.entries.firstOrNull { it.rawValue == type },
        name = name
    )