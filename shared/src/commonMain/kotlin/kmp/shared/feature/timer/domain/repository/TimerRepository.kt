package kmp.shared.feature.timer.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.timer.domain.model.*

internal interface TimerRepository {
    suspend fun readEntries(): Result<List<TimerEntry>>

    suspend fun readEntryPreviews(): Result<List<TimerEntryPreview>>

    suspend fun readProject(
        clientId: String,
        projectId: String
    ): Result<Project>

    suspend fun readClient(
        clientId: String
    ): Result<Client>

    suspend fun readTimerData(): Result<TimerData>

    suspend fun readTimerDataPreview(): Result<TimerDataPreview>

    suspend fun readAllProjects(): Result<List<Project>>

    suspend fun readAllProjectPreviews(): Result<List<ProjectPreview>>

    suspend fun updateTimerData(timerData: TimerData): Result<Unit>

    suspend fun createEntry(entry: NewTimerEntry): Result<Unit>

    suspend fun deleteEntry(entryId: String): Result<Unit>

    suspend fun readTimerSummaries(): Result<List<TimerSummary>>
}