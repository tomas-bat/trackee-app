package app.trackee.backend.infrastructure.model.client

import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.infrastructure.model.project.FirestoreProject
import app.trackee.backend.infrastructure.model.project.toDomain
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreClient(
    val id: String = "",
    val name: String = "",
    val projects: List<FirestoreProject> = emptyList()
)

internal fun FirestoreClient.toDomain(): Client = Client(
    id = id,
    name = name,
    projects = projects.map { it.toDomain() }
)