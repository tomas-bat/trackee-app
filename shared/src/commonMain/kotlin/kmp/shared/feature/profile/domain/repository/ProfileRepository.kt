package kmp.shared.feature.profile.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.profile.domain.model.NewClient
import kmp.shared.feature.profile.domain.model.NewClientResponse
import kmp.shared.feature.profile.domain.model.NewProject
import kmp.shared.feature.profile.domain.model.NewProjectResponse
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.domain.model.Project
import kmp.shared.feature.timer.domain.model.ProjectPreview

internal interface ProfileRepository {
    suspend fun readClients(): Result<List<Client>>

    suspend fun readClientCount(): Result<Long>

    suspend fun createClient(client: NewClient): Result<NewClientResponse>

    suspend fun readClient(clientId: String): Result<Client>

    suspend fun updateClient(client: Client): Result<Unit>

    suspend fun deleteClient(clientId: String): Result<Unit>

    suspend fun assignClientToUser(clientId: String): Result<Unit>

    suspend fun createProject(project: NewProject): Result<NewProjectResponse>

    suspend fun readProjectPreview(clientId: String, projectId: String): Result<ProjectPreview>

    suspend fun updateProject(originalClientId: String, project: Project): Result<Unit>

    suspend fun deleteProject(clientId: String, projectId: String): Result<Unit>

    suspend fun assignProjectToUser(clientId: String, projectId: String): Result<Unit>

    suspend fun deleteUser(): Result<Unit>

    suspend fun readUserEmail(): Result<String>
}