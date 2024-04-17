package kmp.shared.feature.timer.data.repository

import kmp.shared.base.Result
import kmp.shared.base.paging.Page
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.domain.model.*
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kmp.shared.feature.timer.infrastructure.model.toDomain
import kmp.shared.feature.timer.infrastructure.model.toDto
import kotlinx.datetime.Instant

internal class TimerRepositoryImpl(
    private val timerSource: TimerSource
) : TimerRepository {
    override suspend fun readEntries(
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Result<Page<TimerEntry>> =
        timerSource.readEntries(
            startAfter = startAfter?.toString(),
            limit = limit,
            endAt = endAt?.toString()
        ).map { it.toDomain() }

    override suspend fun readEntryPreviews(
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Result<Page<TimerEntryPreview>> =
        timerSource.readEntryPreviews(
            startAfter = startAfter?.toString(),
            limit = limit,
            endAt = endAt?.toString()
        ).map { it.toDomain() }

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

    override suspend fun updateTimerData(timerData: TimerData): Result<Unit> =
        timerSource.updateTimerData(timerData.toDto())

    override suspend fun createEntry(entry: NewTimerEntry): Result<Unit> =
        timerSource.createEntry(entry.toDto())

    override suspend fun deleteEntry(entryId: String): Result<Unit> =
        timerSource.deleteEntry(entryId)

    override suspend fun readTimerSummaries(): Result<List<TimerSummary>> =
        timerSource.readTimerSummaries().map { list -> list.mapNotNull { it.toDomain() } }

    override suspend fun startTimer(): Result<Unit> =
        timerSource.startTimer()
}