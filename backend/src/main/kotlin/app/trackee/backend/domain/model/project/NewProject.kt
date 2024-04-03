package app.trackee.backend.domain.model.project

data class NewProject(
    val clientId: String,
    val type: ProjectType?,
    val name: String
)