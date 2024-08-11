package kmp.shared.feature.timer.domain.model

data class Project(
    val id: String,
    val clientId: String,
    val type: ProjectType?,
    val name: String,
    val color: ProjectColor?
)