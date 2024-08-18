package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.BaseException
import app.trackee.backend.config.exceptions.ClockifyException
import app.trackee.backend.data.source.ClockifySource
import app.trackee.backend.domain.model.clockify.*
import app.trackee.backend.infrastructure.model.clockify.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import io.ktor.http.*

internal class ClockifySourceImpl(
    private val client: HttpClient
) : ClockifySource {

    private val apiUrl = "https://api.clockify.me/api/v1"
    private val apiKeyHeader = "x-api-key"

    override suspend fun readWorkspaces(apiKey: String): List<ClockifyWorkspace> =
        runHandlingClockifyExceptions {
            client.get(urlWith("workspaces")) {
                header(apiKeyHeader, apiKey)
            }.body<List<RawClockifyWorkspace>>().map { it.toDomain() }
        }

    override suspend fun readProjectByName(
        apiKey: String,
        workspaceId: String,
        projectName: String,
        clientName: String
    ): ClockifyProject =
       runHandlingClockifyExceptions {
            val projects = client.get(urlWith("workspaces/${workspaceId}/projects")) {
                header(apiKeyHeader, apiKey)
                url {
                    parameters.append("name", projectName)
                    parameters.append("strict-name-search", "false")
                }
            }.body<List<RawClockifyProject>>().map { it.toDomain() }

            return projects.firstOrNull { it.clientName == clientName }
                ?: throw ClockifyException.ClockifyProjectNotFound(null, projectName)
        }

    override suspend fun createTimeEntry(
        apiKey: String,
        workspaceId: String,
        entry: NewClockifyTimeEntry
    ): ClockifyCreateTimeEntryResponse = runHandlingClockifyExceptions {
        client.post(urlWith("workspaces/${workspaceId}/time-entries")) {
            contentType(ContentType.Application.Json)
            header(apiKeyHeader, apiKey)
            setBody(entry.toRaw())
        }.body<RawClockifyCreateTimeEntryResponse>().toDomain()
    }

    override suspend fun readTimeEntry(
        apiKey: String,
        workspaceId: String,
        entryId: String
    ): ClockifyTimeEntry = runHandlingClockifyExceptions {
        client.get(urlWith("workspaces/${workspaceId}/time-entries/${entryId}")) {
            contentType(ContentType.Application.Json)
            header(apiKeyHeader, apiKey)
        }.body<RawClockifyTimeEntry>().toDomain()
    }

    override suspend fun updateTimeEntry(
        apiKey: String,
        workspaceId: String,
        entry: ClockifyTimeEntry
    ): ClockifyUpdateTimeEntryResponse = runHandlingClockifyExceptions {
        client.put(urlWith("workspaces/${workspaceId}/time-entries/${entry.id}")) {
            contentType(ContentType.Application.Json)
            header(apiKeyHeader, apiKey)
            setBody(entry.toRaw())
        }.body<RawClockifyUpdateTimeEntryResponse>().toDomain()
    }

    override suspend fun removeTimeEntry(apiKey: String, workspaceId: String, clockifyEntryId: String) =
        runHandlingClockifyExceptions {
            client.delete(urlWith("workspaces/${workspaceId}/time-entries/${clockifyEntryId}")) {
                contentType(ContentType.Application.Json)
                header(apiKeyHeader, apiKey)
            }
            return@runHandlingClockifyExceptions
        }

    override suspend fun readWorkspace(apiKey: String, workspaceId: String): ClockifyWorkspace =
        runHandlingClockifyExceptions {
            client.get(urlWith("workspaces/${workspaceId}")) {
                contentType(ContentType.Application.Json)
                header(apiKeyHeader, apiKey)
            }.body<RawClockifyWorkspace>().toDomain()
        }

    private fun urlWith(endpoint: String): String =
        "${apiUrl}/${endpoint}"

    private suspend inline fun <R : Any> runHandlingClockifyExceptions(block: () -> R): R =
        try {
            block()
        } catch (e: Throwable) {
            when (val exception = e as Exception) {
                is ClientRequestException -> {
                    val error = exception.response.body<RawClockifyError>()
                    throw when (error.code) {
                        4003 -> ClockifyException.ClockifyInvalidApiKey("Code: ${error.code}, message: ${error.message}")
                        else -> ClockifyException.ClockifyUnknownError("Code: ${error.code}, message: ${error.message}")
                    }
                }
                is BaseException -> throw exception
                else -> throw ClockifyException.ClockifyUnknownError(exception.message)
            }
        }
}