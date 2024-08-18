package kmp.shared.feature.timer.infrastructure.source

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.base.paging.PageDto
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.infrastructure.model.*

internal class RemoteTimerSource(
    private val client: HttpClient
) : TimerSource {
    override suspend fun readEntry(entryId: String): Result<TimerEntryPreviewDto> =
        runCatchingCommonNetworkExceptions {
            client.get("user/entries/${entryId}/preview").body<TimerEntryPreviewDto>()
        }

    override suspend fun readEntries(
        startAfter: String?,
        limit: Int?,
        endAt: String?
    ): Result<PageDto<TimerEntryDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/entries") {
                url {
                    startAfter?.let { parameters.append("startAfter", it) }
                    limit?.let { parameters.append("limit", it.toString()) }
                    endAt?.let { parameters.append("endAt", it) }
                }
            }
            res.body<PageDto<TimerEntryDto>>()
        }

    override suspend fun readEntryPreviews(
        startAfter: String?,
        limit: Int?,
        endAt: String?
    ): Result<PageDto<TimerEntryPreviewDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/entries/previews") {
                url {
                    startAfter?.let { parameters.append("startAfter", it) }
                    limit?.let { parameters.append("limit", it.toString()) }
                    endAt?.let { parameters.append("endAt", it) }
                }
            }
            res.body<PageDto<TimerEntryPreviewDto>>()
        }

    override suspend fun updateEntry(entry: TimerEntryDto): Result<TimerEntryDto> =
        runCatchingCommonNetworkExceptions {
            client.put("user/entries/${entry.id}") {
                setBody(entry)
            }.body<TimerEntryDto>()
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

    override suspend fun readTimerData(): Result<TimerDataDto> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/timer")
            res.body<TimerDataDto>()
        }

    override suspend fun readTimerDataPreview(): Result<TimerDataPreviewDto> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/timer/preview")
            res.body<TimerDataPreviewDto>()
        }

    override suspend fun readAllProjects(): Result<List<ProjectDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/projects")
            res.body<List<ProjectDto>>()
        }

    override suspend fun readAllProjectPreviews(): Result<List<ProjectPreviewDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/projects/previews")
            res.body<List<ProjectPreviewDto>>()
        }

    override suspend fun updateTimerData(timerData: TimerDataDto): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("user/timer") {
                setBody(timerData)
            }

            Result.Success(Unit)
        }

    override suspend fun createEntry(entry: NewTimerEntryDto): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.post("user/entries") {
                setBody(entry)
            }

            Result.Success(Unit)
        }

    override suspend fun deleteEntry(entryId: String): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.delete("user/entries/${entryId}")
            Result.Success(Unit)
        }

    override suspend fun readTimerSummaries(): Result<List<TimerSummaryDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("/user/summaries")
            res.body<List<TimerSummaryDto>>()
        }
}