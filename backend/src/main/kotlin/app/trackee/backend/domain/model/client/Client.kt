package app.trackee.backend.domain.model.client

import app.trackee.backend.domain.model.project.Project

data class Client(
    val id: String,
    val name: String,
    val projects: List<Project>
)