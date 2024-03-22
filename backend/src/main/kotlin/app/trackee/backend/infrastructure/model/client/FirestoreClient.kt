package app.trackee.backend.infrastructure.model.client

import app.trackee.backend.domain.model.client.Client

internal data class FirestoreClient(
    val id: String = "",
    val name: String = "",
)

internal fun FirestoreClient.toDomain(): Client = Client(
    id = id,
    name = name
)