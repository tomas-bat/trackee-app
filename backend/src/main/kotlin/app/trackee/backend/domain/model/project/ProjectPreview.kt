package app.trackee.backend.domain.model.project

import app.trackee.backend.domain.model.client.Client

data class ProjectPreview(
    val id: String,
    val client: Client,
    val type: ProjectType?,
    val name: String,
    val color: ProjectColor?
)