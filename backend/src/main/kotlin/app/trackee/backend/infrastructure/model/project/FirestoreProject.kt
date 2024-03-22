package app.trackee.backend.infrastructure.model.project

import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectType
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreProject(
    val id: String = "",
    val client_id: String = "",
    val type: String? = null,
    val name: String = ""
)

internal fun FirestoreProject.toDomain(): Project = Project(
    id = id,
    clientId = client_id,
    type = ProjectType.entries.firstOrNull { it.rawValue == type },
    name = name
)