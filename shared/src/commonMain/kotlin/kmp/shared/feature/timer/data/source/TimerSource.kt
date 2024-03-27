package kmp.shared.feature.timer.data.source

import kmp.shared.base.Result
import kmp.shared.feature.timer.infrastructure.model.*

internal interface TimerSource {
    suspend fun readEntries(): Result<List<TimerEntryDto>>

    suspend fun readEntryPreviews(): Result<List<TimerEntryPreviewDto>>

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
}