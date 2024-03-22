package app.trackee.backend.data.source

import app.trackee.backend.infrastructure.model.client.FirestoreClient
import app.trackee.backend.infrastructure.model.project.FirestoreProject

internal interface ClientSource {
    suspend fun readClientById(id: String): FirestoreClient

    suspend fun readProjectsForClient(clientId: String): List<FirestoreProject>

    suspend fun readProjectById(clientId: String, projectId: String): FirestoreProject
}