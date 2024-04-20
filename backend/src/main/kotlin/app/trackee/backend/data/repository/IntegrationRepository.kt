package app.trackee.backend.data.repository

import app.trackee.backend.data.source.IntegrationSource
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.data.util.asCsvDate
import app.trackee.backend.data.util.asCsvTime
import app.trackee.backend.data.util.durationDecimal
import app.trackee.backend.data.util.durationHours
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration
import app.trackee.backend.domain.repository.IntegrationRepository
import java.io.File
import java.util.*
import kotlin.io.path.Path
import kotlin.io.path.createParentDirectories
import kotlin.io.path.deleteIfExists
import kotlin.io.path.listDirectoryEntries

internal class IntegrationRepositoryImpl(
    private val source: IntegrationSource,
    private val userSource: UserSource
) : IntegrationRepository {

    private val csvPath = "temp/csv"

    override suspend fun createIntegration(uid: String, integration: NewIntegration) =
        source.createIntegration(uid, integration)

    override suspend fun readIntegration(uid: String, integrationId: String): Integration =
        source.readIntegration(uid, integrationId)

    override suspend fun readIntegrations(uid: String): List<Integration> =
        source.readIntegrations(uid)

    override suspend fun updateIntegration(uid: String, integration: Integration) =
        source.updateIntegration(uid, integration)

    override suspend fun deleteIntegration(uid: String, integrationId: String) =
        source.deleteIntegration(uid, integrationId)

    override suspend fun readCsv(entries: List<TimerEntryPreview>): File {

        val filename = UUID.randomUUID().toString()
        val csvPath = Path("${csvPath}/${filename}.csv")
        csvPath.createParentDirectories()
        val csv = File(csvPath.toString())

        csv.bufferedWriter().use { writer ->
            writer.write("\"Project\",\"Client\",\"Description\",\"Start Date\",\"Start Time\",\"End Date\",\"End Time\",\"Duration (h)\",\"Duration (decimal)\"\n")
            entries.forEach { entry ->
                writer.write("\"${entry.project.name}\",")
                writer.write("\"${entry.client.name}\",")
                writer.write("\"${entry.description ?: ""}\",")
                writer.write("\"${entry.startedAt.asCsvDate}\",")
                writer.write("\"${entry.startedAt.asCsvTime}\",")
                writer.write("\"${entry.endedAt.asCsvDate}\",")
                writer.write("\"${entry.endedAt.asCsvTime}\",")
                writer.write("\"${entry.durationHours}\",")
                writer.write("\"${entry.durationDecimal}\"\n")
            }
        }

        return csv
    }

    override suspend fun deleteTempCsvFiles() {
        Path(csvPath).listDirectoryEntries().forEach { file ->
            file.deleteIfExists()
        }
    }
}