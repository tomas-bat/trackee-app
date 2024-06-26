package app.trackee.backend.data.source

import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.NewProjectResponse
import app.trackee.backend.infrastructure.model.project.FirestoreProject

internal interface ProjectSource {
    suspend fun createProject(project: NewProject): NewProjectResponse

    suspend fun updateProject(originalClientId: String, project: FirestoreProject)

    suspend fun deleteProject(clientId: String, projectId: String)
}