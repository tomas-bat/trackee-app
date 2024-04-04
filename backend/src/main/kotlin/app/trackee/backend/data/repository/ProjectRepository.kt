package app.trackee.backend.data.repository

import app.trackee.backend.data.source.ClientSource
import app.trackee.backend.data.source.ProjectSource
import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.NewProjectResponse
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectPreview
import app.trackee.backend.domain.repository.ProjectRepository
import app.trackee.backend.infrastructure.model.client.toDomain
import app.trackee.backend.infrastructure.model.project.toDomain
import app.trackee.backend.infrastructure.model.project.toFirestore

internal class ProjectRepositoryImpl(
    private val source: ProjectSource,
    private val clientSource: ClientSource
) : ProjectRepository {

    override suspend fun createProject(project: NewProject): NewProjectResponse =
        source.createProject(project)

    override suspend fun readProjectPreview(clientId: String, projectId: String): ProjectPreview {
        val project = clientSource.readProjectById(clientId, projectId).toDomain()

        return ProjectPreview(
            id = project.id,
            client = clientSource.readClientById(clientId).toDomain(),
            type = project.type,
            name = project.name
        )
    }

    override suspend fun updateProject(project: Project) =
        source.updateProject(project.toFirestore())

    override suspend fun deleteProject(clientId: String, projectId: String) =
        source.deleteProject(clientId, projectId)
}