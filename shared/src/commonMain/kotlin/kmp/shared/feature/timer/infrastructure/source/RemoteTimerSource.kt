package kmp.shared.feature.timer.infrastructure.source

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.infrastructure.model.ClientDto
import kmp.shared.feature.timer.infrastructure.model.ProjectDto
import kmp.shared.feature.timer.infrastructure.model.TimerEntryDto

internal class RemoteTimerSource(
    private val client: HttpClient
) : TimerSource {
    override suspend fun readEntries(uid: String): Result<List<TimerEntryDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("users/${uid}/entries")
            res.body<List<TimerEntryDto>>()
        }

    override suspend fun readProject(clientId: String, projectId: String): Result<ProjectDto> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("clients/${clientId}/projects/${projectId}")
            res.body<ProjectDto>()
        }

    override suspend fun readClient(clientId: String): Result<ClientDto> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("clients/${clientId}")
            res.body<ClientDto>()
        }
}