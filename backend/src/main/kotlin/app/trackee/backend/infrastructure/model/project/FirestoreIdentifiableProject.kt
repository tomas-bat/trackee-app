package app.trackee.backend.infrastructure.model.project

import app.trackee.backend.domain.model.project.IdentifiableProject
import com.google.cloud.firestore.annotation.PropertyName

internal data class FirestoreIdentifiableProject(
    @get:PropertyName("client_id")
    @set:PropertyName("client_id")
    var clientId: String = "",

    @get:PropertyName("project_id")
    @set:PropertyName("project_id")
    var projectId: String = ""
)

internal fun FirestoreIdentifiableProject.toDomain() = IdentifiableProject(
    clientId = clientId,
    projectId = projectId
)

internal fun IdentifiableProject.toFirestore() = FirestoreIdentifiableProject(
    clientId = clientId,
    projectId = projectId
)