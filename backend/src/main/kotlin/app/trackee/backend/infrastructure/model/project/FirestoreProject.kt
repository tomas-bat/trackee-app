package app.trackee.backend.infrastructure.model.project

import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectColor
import app.trackee.backend.domain.model.project.ProjectType
import com.google.cloud.firestore.annotation.PropertyName


internal data class FirestoreProject(
    val id: String = "",
    val type: String? = null,
    val name: String = "",
    val color: String? = null,

    @get:PropertyName("client_id")
    @set:PropertyName("client_id")
    var clientId: String = ""
)

internal fun FirestoreProject.toDomain(): Project = Project(
    id = id,
    clientId = clientId,
    type = ProjectType.entries.firstOrNull { it.rawValue == type },
    name = name,
    color = ProjectColor.entries.firstOrNull { it.rawValue == color },
)

internal fun NewProject.toFirestore(id: String) = FirestoreProject(
    id = id,
    type = type?.rawValue,
    name = name,
    clientId = clientId,
    color = color?.rawValue
)

internal fun Project.toFirestore() = FirestoreProject(
    id = id,
    type = type?.rawValue,
    name = name,
    clientId = clientId,
    color = color?.rawValue
)