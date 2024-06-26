package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.NewProjectResponse
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectPreview

interface ProjectRepository {

    suspend fun createProject(project: NewProject): NewProjectResponse

    suspend fun readProjectPreview(clientId: String, projectId: String): ProjectPreview

    suspend fun updateProject(originalClientId: String, project: Project)

    suspend fun deleteProject(clientId: String, projectId: String)
}