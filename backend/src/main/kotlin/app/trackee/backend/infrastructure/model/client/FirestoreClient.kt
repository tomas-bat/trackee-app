package app.trackee.backend.infrastructure.model.client

import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.client.NewClient

internal data class FirestoreClient(
    val id: String = "",
    val name: String = "",
)

internal fun FirestoreClient.toDomain(): Client = Client(
    id = id,
    name = name
)

internal fun Client.toFirestore() = FirestoreClient(
    id = id,
    name = name
)

internal fun NewClient.toFirestore(id: String) = FirestoreClient(
    id = id,
    name = name
)