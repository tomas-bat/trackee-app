package kmp.shared.feature.timer.data.source

import kmp.shared.base.Result
import kmp.shared.feature.timer.infrastructure.model.*

internal interface TimerSource {
    suspend fun readEntries(
        startAfter: String?,
        limit: Int?,
        endAt: String?
    ): Result<List<TimerEntryDto>>

    suspend fun readEntryPreviews(
        startAfter: String?,
        limit: Int?,
        endAt: String?
    ): Result<List<TimerEntryPreviewDto>>

    suspend fun readProject(
        clientId: String,
        projectId: String
    ): Result<ProjectDto>

    suspend fun readClient(
        clientId: String
    ): Result<ClientDto>

    suspend fun readTimerData(): Result<TimerDataDto>

    suspend fun readTimerDataPreview(): Result<TimerDataPreviewDto>

    suspend fun readAllProjects(): Result<List<ProjectDto>>

    suspend fun readAllProjectPreviews(): Result<List<ProjectPreviewDto>>

    suspend fun updateTimerData(timerData: TimerDataDto): Result<Unit>

    suspend fun createEntry(entry: NewTimerEntryDto): Result<Unit>

    suspend fun deleteEntry(entryId: String): Result<Unit>

    suspend fun readTimerSummaries(): Result<List<TimerSummaryDto>>

    suspend fun startTimer(): Result<Unit>
}