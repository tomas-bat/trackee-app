package app.trackee.backend.data.repository

import app.trackee.backend.config.exceptions.ClockifyException
import app.trackee.backend.config.exceptions.IntegrationException
import app.trackee.backend.data.source.ClockifySource
import app.trackee.backend.data.source.IntegrationSource
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.data.util.*
import app.trackee.backend.domain.model.clockify.*
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration
import app.trackee.backend.domain.model.project.IdentifiableProject
import app.trackee.backend.domain.repository.IntegrationRepository
import java.io.File
import java.util.*
import kotlin.io.path.Path
import kotlin.io.path.createParentDirectories
import kotlin.io.path.deleteIfExists
import kotlin.io.path.listDirectoryEntries

internal class IntegrationRepositoryImpl(
    private val source: IntegrationSource,
    private val clockify: ClockifySource,
    private val user: UserSource
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

    override suspend fun deleteTempCsvFile(filename: String) {
        Path("${csvPath}/${filename}").deleteIfExists()
    }

    override suspend fun deleteTempCsvFiles() {
        Path(csvPath).listDirectoryEntries().forEach { file ->
            file.deleteIfExists()
        }
    }

    override suspend fun createClockifyEntry(
        uid: String,
        apiKey: String,
        entry: TimerEntryPreview,
        workspaceName: String?
    ): ClockifyCreateTimeEntryResult {
        val workspaceId = clockify.readWorkspaces(apiKey).firstOrNull { it.name == workspaceName }?.id
            ?: throw ClockifyException.ClockifyWorkspaceNotFound(workspaceName)

        val projectId = clockify.readProjectByName(
            apiKey = apiKey,
            workspaceId = workspaceId,
            projectName = entry.project.name,
            clientName = entry.client.name
        ).id

        val clockifyEntry = NewClockifyTimeEntry(
            billable = true,
            description = entry.description ?: "",
            customAttributes = emptyList(),
            customFields = emptyList(),
            end = entry.endedAt.asClockifyDate,
            projectId = projectId,
            start = entry.startedAt.asClockifyDate,
            tagIds = emptyList(),
            taskId = "",
            type = ClockifyTimeEntryType.Regular
        )

        val result = ClockifyCreateTimeEntryResult(
            response = clockify.createTimeEntry(apiKey, workspaceId, clockifyEntry),
            workspaceId = workspaceId
        )

        user.addClockifyDataToEntry(uid, entry.id, result.response.id, workspaceId)

        return result
    }

    override suspend fun updateClockifyEntry(
        apiKey: String,
        entry: TimerEntryPreview
    ): ClockifyTimeEntry {
        val projectId = clockify.readProjectByName(
            apiKey = apiKey,
            workspaceId = entry.clockifyWorkspaceId ?: throw IntegrationException.MissingClockifyWorkspaceId(entry.id),
            projectName = entry.project.name,
            clientName = entry.client.name
        ).id

        val clockifyEntry = ClockifyTimeEntry(
            id = entry.clockifyEntryId ?: throw IntegrationException.MissingClockifyEntryId(entry.id),
            billable = true,
            description = entry.description ?: "",
            customAttributes = emptyList(),
            customFields = emptyList(),
            end = entry.endedAt.asClockifyDate,
            projectId = projectId,
            start = entry.startedAt.asClockifyDate,
            tagIds = emptyList(),
            taskId = "",
            type = ClockifyTimeEntryType.Regular
        )

        return clockify.updateTimeEntry(
            apiKey = apiKey,
            workspaceId = entry.clockifyWorkspaceId,
            entry = clockifyEntry
        )
    }

    override suspend fun removeClockifyEntry(
        apiKey: String,
        clockifyWorkspaceId: String,
        clockifyEntryId: String,
    ) =
        clockify.removeTimeEntry(apiKey, clockifyWorkspaceId, clockifyEntryId)

    override suspend fun readClockifyWorkspace(apiKey: String, workspaceId: String): ClockifyWorkspace =
        clockify.readWorkspace(apiKey, workspaceId)


    override suspend fun readActiveClockifyAutoExportIntegrations(uid: String): List<Integration.Clockify> =
        readIntegrations(uid)
            .filterIsInstance<Integration.Clockify>()
            .filter { it.autoExport && it.apiKey != null && it.workspaceName != null }

    override suspend fun createEntryForAutoExports(uid: String, entry: TimerEntryPreview) {
        readActiveClockifyAutoExportIntegrations(uid)
            .filter { it.selectedProjects.contains(IdentifiableProject(entry.project.id, entry.client.id)) }
            .forEach { clockify ->
                createClockifyEntry(
                    uid = uid,
                    apiKey = clockify.apiKey ?: "",
                    entry = entry,
                    workspaceName = clockify.workspaceName ?: ""
                )
            }
    }

    override suspend fun inferClockifyApiKey(
        uid: String,
        entry: TimerEntry
    ): String =
        readActiveClockifyAutoExportIntegrations(uid)
            .firstOrNull { autoExport ->
                try {
                    if (autoExport.apiKey == null || entry.clockifyWorkspaceId == null) return@firstOrNull false
                    readClockifyWorkspace(
                        apiKey = autoExport.apiKey,
                        workspaceId = entry.clockifyWorkspaceId
                    )
                    return@firstOrNull true
                } catch (e: Exception) {
                    return@firstOrNull false
                }
            }
            ?.apiKey ?: throw IntegrationException.UnableToInferApiKey(entry.id)
}