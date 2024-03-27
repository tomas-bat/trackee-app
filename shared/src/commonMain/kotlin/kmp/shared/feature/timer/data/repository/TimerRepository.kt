package kmp.shared.feature.timer.data.repository

import kmp.shared.base.Result
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.domain.model.*
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kmp.shared.feature.timer.infrastructure.model.toDomain

internal class TimerRepositoryImpl(
    private val timerSource: TimerSource
) : TimerRepository {
    override suspend fun readEntries(): Result<List<TimerEntry>> =
        timerSource.readEntries().map { list -> list.map { entry -> entry.toDomain() } }

    override suspend fun readEntryPreviews(): Result<List<TimerEntryPreview>> =
        timerSource.readEntryPreviews().map { list -> list.map { entry -> entry.toDomain() } }

    override suspend fun readProject(clientId: String, projectId: String): Result<Project> =
        timerSource.readProject(clientId, projectId).map { it.toDomain() }

    override suspend fun readClient(clientId: String): Result<Client> =
        timerSource.readClient(clientId).map { it.toDomain() }

    override suspend fun readTimerData(): Result<TimerData> =
        timerSource.readTimerData().map { it.toDomain() }

    override suspend fun readTimerDataPreview(): Result<TimerDataPreview> =
        timerSource.readTimerDataPreview().map { it.toDomain(type = TimerType.Timer) } // TODO: remember timer type

    override suspend fun readAllProjects(): Result<List<Project>> =
        timerSource.readAllProjects().map { list -> list.map { it.toDomain() } }

    override suspend fun readAllProjectPreviews(): Result<List<ProjectPreview>> =
        timerSource.readAllProjectPreviews().map { list -> list.map { it.toDomain() } }
}