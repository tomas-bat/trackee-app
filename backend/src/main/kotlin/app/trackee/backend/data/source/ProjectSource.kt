package app.trackee.backend.data.source

import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.infrastructure.model.project.FirestoreProject

internal interface ProjectSource {
    suspend fun createProject(project: NewProject)

    suspend fun updateProject(project: FirestoreProject)

    suspend fun deleteProject(clientId: String, projectId: String)
}