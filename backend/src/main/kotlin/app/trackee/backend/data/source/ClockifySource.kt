package app.trackee.backend.data.source

import app.trackee.backend.domain.model.clockify.ClockifyProject
import app.trackee.backend.domain.model.clockify.ClockifyTimeEntry
import app.trackee.backend.domain.model.clockify.ClockifyWorkspace

internal interface ClockifySource {
    suspend fun readWorkspaces(apiKey: String): List<ClockifyWorkspace>

    suspend fun readProjectByName(
        apiKey: String,
        workspaceId: String,
        projectName: String,
        clientName: String
    ): ClockifyProject

    suspend fun createTimeEntry(
        apiKey: String,
        workspaceId: String,
        entry: ClockifyTimeEntry
    )
}