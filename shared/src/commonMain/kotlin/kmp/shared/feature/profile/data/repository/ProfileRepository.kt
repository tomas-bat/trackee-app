package kmp.shared.feature.profile.data.repository

import kmp.shared.base.Result
import kmp.shared.base.util.extension.map
import kmp.shared.feature.profile.data.source.RemoteProfileSource
import kmp.shared.feature.profile.domain.model.NewClient
import kmp.shared.feature.profile.domain.model.NewClientResponse
import kmp.shared.feature.profile.domain.model.NewProject
import kmp.shared.feature.profile.domain.model.NewProjectResponse
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.domain.model.Project
import kmp.shared.feature.timer.domain.model.ProjectPreview
import kmp.shared.feature.timer.infrastructure.model.toDomain

internal class ProfileRepositoryImpl(
    private val source: RemoteProfileSource
) : ProfileRepository {
    override suspend fun readClients(): Result<List<Client>> =
        source.readClients().map { list -> list.map { it.toDomain() } }

    override suspend fun createClient(client: NewClient): Result<NewClientResponse> =
        source.createClient(client)

    override suspend fun readClient(clientId: String): Result<Client> =
        source.readClient(clientId)

    override suspend fun updateClient(client: Client): Result<Unit> =
        source.updateClient(client)

    override suspend fun deleteClient(clientId: String): Result<Unit> =
        source.deleteClient(clientId)

    override suspend fun assignClientToUser(clientId: String): Result<Unit> =
        source.assignClientToUser(clientId)

    override suspend fun createProject(project: NewProject): Result<NewProjectResponse> =
        source.createProject(project)

    override suspend fun readProjectPreview(clientId: String, projectId: String): Result<ProjectPreview> =
        source.readProjectPreview(clientId, projectId)

    override suspend fun updateProject(originalClientId: String, project: Project): Result<Unit> =
        source.updateProject(originalClientId, project)

    override suspend fun deleteProject(clientId: String, projectId: String): Result<Unit> =
        source.deleteProject(clientId, projectId)

    override suspend fun assignProjectToUser(clientId: String, projectId: String): Result<Unit> =
        source.assignProjectToUser(clientId, projectId)

    override suspend fun deleteUser(): Result<Unit> =
        source.deleteUser()
}