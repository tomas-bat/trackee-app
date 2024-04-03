package app.trackee.backend.data.repository

import app.trackee.backend.data.source.ProjectSource
import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.repository.ProjectRepository
import app.trackee.backend.infrastructure.model.project.toFirestore

internal class ProjectRepositoryImpl(
    private val source: ProjectSource
) : ProjectRepository {

    override suspend fun createProject(project: NewProject) =
        source.createProject(project)

    override suspend fun updateProject(project: Project) =
        source.updateProject(project.toFirestore())

    override suspend fun deleteProject(clientId: String, projectId: String) =
        source.deleteProject(clientId, projectId)
}