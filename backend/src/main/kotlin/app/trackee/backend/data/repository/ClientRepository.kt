package app.trackee.backend.data.repository

import app.trackee.backend.data.source.ClientSource
import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.client.NewClient
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.repository.ClientRepository
import app.trackee.backend.infrastructure.model.client.toDomain
import app.trackee.backend.infrastructure.model.client.toFirestore
import app.trackee.backend.infrastructure.model.project.toDomain

internal class ClientRepositoryImpl(
    private val source: ClientSource
) : ClientRepository {
    override suspend fun readClientById(id: String): Client =
        source.readClientById(id).toDomain()

    override suspend fun readProjectsForClient(clientId: String): List<Project> =
        source.readProjectsForClient(clientId).map { it.toDomain() }

    override suspend fun readProject(clientId: String, projectId: String): Project =
        source.readProjectById(clientId, projectId).toDomain()

    override suspend fun createClient(client: NewClient) =
        source.createClient(client)

    override suspend fun updateClient(client: Client) =
        source.updateClient(client.toFirestore())

    override suspend fun deleteClient(clientId: String) =
        source.deleteClient(clientId)
}