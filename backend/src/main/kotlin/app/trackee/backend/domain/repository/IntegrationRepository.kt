package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.integration.ActiveClockifyAutoExport
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
        apiKey: String,
        entry: TimerEntryPreview,
        workspaceName: String? = null
    )

    suspend fun readActiveClockifyAutoExports(uid: String): List<ActiveClockifyAutoExport>

    suspend fun createEntryForAutoExports(uid: String, entry: TimerEntryPreview)
}