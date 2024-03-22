package app.trackee.backend.domain.model.project

data class Project(
    val id: String,
    val clientId: String,
    val type: ProjectType?,
    val name: String
)