package kmp.shared.feature.profile.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.profile.domain.model.NewClient
import kmp.shared.feature.profile.domain.model.NewClientResponse
import kmp.shared.feature.profile.domain.model.NewProject
import kmp.shared.feature.profile.domain.model.NewProjectResponse
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.domain.model.Project

internal interface ProfileRepository {
    suspend fun readClients(): Result<List<Client>>

    suspend fun createClient(client: NewClient): Result<NewClientResponse>

    suspend fun updateClient(client: Client): Result<Unit>

    suspend fun deleteClient(clientId: String): Result<Unit>

    suspend fun assignClientToUser(clientId: String): Result<Unit>

    suspend fun createProject(project: NewProject): Result<NewProjectResponse>

    suspend fun updateProject(project: Project): Result<Unit>

    suspend fun deleteProject(clientId: String, projectId: String): Result<Unit>

    suspend fun assignProjectToUser(clientId: String, projectId: String): Result<Unit>
}