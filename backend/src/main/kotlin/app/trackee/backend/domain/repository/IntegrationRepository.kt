package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.clockify.ClockifyCreateTimeEntryResult
import app.trackee.backend.domain.model.clockify.ClockifyTimeEntry
import app.trackee.backend.domain.model.clockify.ClockifyWorkspace
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration
import java.io.File

interface IntegrationRepository {

    suspend fun createIntegration(uid: String, integration: NewIntegration)

    suspend fun readIntegration(uid: String, integrationId: String): Integration

    suspend fun readIntegrations(uid: String): List<Integration>

    suspend fun updateIntegration(uid: String, integration: Integration)

    suspend fun deleteIntegration(uid: String, integrationId: String)

    suspend fun readCsv(entries: List<TimerEntryPreview>): File

    suspend fun deleteTempCsvFile(filename: String)

    suspend fun deleteTempCsvFiles()

    suspend fun createClockifyEntry(
        uid: String,
        apiKey: String,
        entry: TimerEntryPreview,
        workspaceName: String? = null
    ): ClockifyCreateTimeEntryResult

    suspend fun updateClockifyEntry(
        apiKey: String,
        entry: TimerEntryPreview
    ): ClockifyTimeEntry

    suspend fun removeClockifyEntry(
        apiKey: String,
        clockifyWorkspaceId: String,
        clockifyEntryId: String
    )

    suspend fun readClockifyWorkspace(
        apiKey: String,
        workspaceId: String
    ): ClockifyWorkspace

    suspend fun readActiveClockifyAutoExportIntegrations(uid: String): List<Integration.Clockify>

    suspend fun createEntryForAutoExports(uid: String, entry: TimerEntryPreview)

    suspend fun inferClockifyApiKey(uid: String, entry: TimerEntry): String
}