package kmp.shared.feature.timer.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.domain.model.Project
import kmp.shared.feature.timer.domain.model.TimerEntry

internal interface TimerRepository {
    suspend fun readEntries(
        uid: String
    ): Result<List<TimerEntry>>

    suspend fun readProject(
        clientId: String,
        projectId: String
    ): Result<Project>

    suspend fun readClient(
        clientId: String
    ): Result<Client>
}