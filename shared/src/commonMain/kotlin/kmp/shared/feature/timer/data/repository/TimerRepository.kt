package kmp.shared.feature.timer.data.repository

import kmp.shared.base.Result
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.domain.model.Project
import kmp.shared.feature.timer.domain.model.TimerEntry
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kmp.shared.feature.timer.infrastructure.model.toDomain

internal class TimerRepositoryImpl(
    private val timerSource: TimerSource
) : TimerRepository {
    override suspend fun readEntries(uid: String): Result<List<TimerEntry>> =
        timerSource.readEntries(uid).map { list -> list.map { entry -> entry.toDomain() } }

    override suspend fun readProject(clientId: String, projectId: String): Result<Project> =
        timerSource.readProject(clientId, projectId).map { it.toDomain() }

    override suspend fun readClient(clientId: String): Result<Client> =
        timerSource.readClient(clientId).map { it.toDomain() }
}