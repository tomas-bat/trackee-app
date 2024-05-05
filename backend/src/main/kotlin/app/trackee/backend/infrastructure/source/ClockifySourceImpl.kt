package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.ClockifyException
import app.trackee.backend.data.source.ClockifySource
import app.trackee.backend.domain.model.clockify.ClockifyProject
import app.trackee.backend.domain.model.clockify.ClockifyTimeEntry
import app.trackee.backend.domain.model.clockify.ClockifyWorkspace
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
        client.get(urlWith("workspaces")) {
            header(apiKeyHeader, apiKey)
        }.body<List<RawClockifyWorkspace>>().map { it.toDomain() }


    override suspend fun readProjectByName(
        apiKey: String,
        workspaceId: String,
        projectName: String,
        clientName: String
    ): ClockifyProject =
       runHandlingClockifyExceptions {
            client.get(urlWith("workspaces/${workspaceId}/projects")) {
                header(apiKeyHeader, apiKey)
                url {
                    parameters.append("name", projectName)
                    parameters.append("strict-name-search", "false")
                }
            }.body<List<RawClockifyProject>>().map { it.toDomain() }.firstOrNull()
                ?: throw ClockifyException.ProjectNotFound(null, projectName)
        }

    override suspend fun createTimeEntry(
        apiKey: String,
        workspaceId: String,
        entry: ClockifyTimeEntry
    ) = runHandlingClockifyExceptions {
        client.post(urlWith("workspaces/${workspaceId}/time-entries")) {
            contentType(ContentType.Application.Json)
            header(apiKeyHeader, apiKey)
            setBody(entry.toRaw())
        }
        Unit
    }

    private fun urlWith(endpoint: String): String =
        "${apiUrl}/${endpoint}"

    private suspend inline fun <R : Any> runHandlingClockifyExceptions(block: () -> R): R =
        try {
            block()
        } catch (e: Throwable) {
            val exception = e as Exception
            val clientException = exception as ClientRequestException
            val error = clientException.response.body<RawClockifyError>()
            throw when (error.code) {
                4003 -> ClockifyException.InvalidApiKey("Code: ${error.code}, message: ${error.message}")
                else -> ClockifyException.Unknown("Code: ${error.code}, message: ${error.message}")
            }
        }
}