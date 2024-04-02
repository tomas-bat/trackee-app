package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.client.NewClient
import app.trackee.backend.domain.model.project.Project

interface ClientRepository {

    suspend fun readClientById(id: String): Client

    suspend fun readProjectsForClient(clientId: String): List<Project>

    suspend fun readProject(clientId: String, projectId: String): Project

    suspend fun createClient(client: NewClient)

    suspend fun updateClient(client: Client)

    suspend fun deleteClient(clientId: String)
}