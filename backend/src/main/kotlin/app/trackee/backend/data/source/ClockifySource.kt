package app.trackee.backend.data.source

import app.trackee.backend.domain.model.clockify.*

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
        entry: NewClockifyTimeEntry
    ): ClockifyCreateTimeEntryResponse

    suspend fun readTimeEntry(
        apiKey: String,
        workspaceId: String,
        entryId: String
    ): ClockifyTimeEntry

    suspend fun updateTimeEntry(
        apiKey: String,
        workspaceId: String,
        entry: ClockifyTimeEntry
    ): ClockifyUpdateTimeEntryResponse

    suspend fun removeTimeEntry(
        apiKey: String,
        workspaceId: String,
        clockifyEntryId: String
    )

    suspend fun readWorkspace(
        apiKey: String,
        workspaceId: String
    ): ClockifyWorkspace
}