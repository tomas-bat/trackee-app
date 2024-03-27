package app.trackee.backend.data.repository

import app.trackee.backend.data.source.ClientSource
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.timer.TimerData
import app.trackee.backend.domain.model.timer.TimerDataPreview
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.infrastructure.model.client.toDomain
import app.trackee.backend.infrastructure.model.entry.toDomain
import app.trackee.backend.infrastructure.model.project.toDomain
import app.trackee.backend.infrastructure.model.timer.toDomain
import app.trackee.backend.infrastructure.model.user.toDomain

internal class UserRepositoryImpl(
    private val source: UserSource,
    private val clientSource: ClientSource
) : UserRepository {
    override suspend fun readUserByUid(uid: String): User =
        source.readUserByUid(uid).toDomain()

    override suspend fun readEntries(uid: String): List<TimerEntry> =
        source.readEntries(uid).map { it.toDomain() }

    override suspend fun readProjects(uid: String): List<Project> =
        source.readProjectIds(uid).map { project ->
            clientSource.readProjectById(project.clientId, project.projectId).toDomain()
        }

    override suspend fun readTimer(uid: String): TimerData =
        source.readUserByUid(uid).timerData.toDomain()

    override suspend fun readTimerPreview(uid: String): TimerDataPreview {
        val timerData = source.readUserByUid(uid).timerData.toDomain()

        return TimerDataPreview(
            status = timerData.status,
            client = timerData.clientId?.let { clientId -> clientSource.readClientById(clientId).toDomain() },
            project = timerData.clientId?.let { clientId ->
                timerData.projectId?.let { projectId ->
                    clientSource.readProjectById(clientId, projectId).toDomain()
                }
            },
            description = timerData.description,
            startedAt = timerData.startedAt,
            availableProjects = readProjects(uid)
        )
    }

    override suspend fun readEntryPreviews(uid: String): List<TimerEntryPreview> =
        source.readEntries(uid)
            .map { it.toDomain() }
            .map { entry ->
                TimerEntryPreview(
                    id = entry.id,
                    project = clientSource.readProjectById(entry.clientId, entry.projectId).toDomain(),
                    client = clientSource.readClientById(entry.clientId).toDomain(),
                    description = entry.description,
                    startedAt = entry.startedAt,
                    endedAt = entry.endedAt
                )
            }
}