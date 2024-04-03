package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.Project

interface ProjectRepository {

    suspend fun createProject(project: NewProject)

    suspend fun updateProject(project: Project)

    suspend fun deleteProject(clientId: String, projectId: String)
}