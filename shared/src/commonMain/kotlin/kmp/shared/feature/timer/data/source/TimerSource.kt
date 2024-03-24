package kmp.shared.feature.timer.data.source

import kmp.shared.base.Result
import kmp.shared.feature.timer.infrastructure.model.ClientDto
import kmp.shared.feature.timer.infrastructure.model.ProjectDto
import kmp.shared.feature.timer.infrastructure.model.TimerDataDto
import kmp.shared.feature.timer.infrastructure.model.TimerEntryDto

internal interface TimerSource {
    suspend fun readEntries(): Result<List<TimerEntryDto>>

    suspend fun readProject(
        clientId: String,
        projectId: String
    ): Result<ProjectDto>

    suspend fun readClient(
        clientId: String
    ): Result<ClientDto>

    suspend fun readTimerData(): Result<TimerDataDto>

    suspend fun readAllProjects(): Result<List<ProjectDto>>
}