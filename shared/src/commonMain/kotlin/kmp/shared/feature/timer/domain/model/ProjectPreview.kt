package kmp.shared.feature.timer.domain.model

data class ProjectPreview(
    val id: String,
    val client: Client,
    val type: ProjectType?,
    val name: String
)