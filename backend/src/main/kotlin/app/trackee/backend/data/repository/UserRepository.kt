package app.trackee.backend.data.repository

import app.trackee.backend.common.Page
import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.data.source.ClientSource
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.entry.length
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectPreview
import app.trackee.backend.domain.model.timer.*
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.infrastructure.model.client.toDomain
import app.trackee.backend.infrastructure.model.entry.toDomain
import app.trackee.backend.infrastructure.model.project.toDomain
import app.trackee.backend.infrastructure.model.timer.toDomain
import app.trackee.backend.infrastructure.model.timer.toFirestore
import app.trackee.backend.infrastructure.model.user.toDomain
import kotlinx.datetime.*

internal class UserRepositoryImpl(
    private val source: UserSource,
    private val clientSource: ClientSource
) : UserRepository {
    override suspend fun readUserByUid(uid: String): User =
        source.readUserByUid(uid).toDomain()

    override suspend fun deleteUser(uid: String) =
        source.deleteUser(uid)

    override suspend fun readEntries(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Page<TimerEntry> {
        val page = source.readEntries(uid, startAfter, limit, endAt)

        return Page(
            data = page.data.map { it.toDomain() },
            isLast = page.isLast
        )
    }

    override suspend fun readProjects(uid: String): List<Project> =
        source.readProjectIds(uid).map { project ->
            clientSource.readProjectById(project.clientId, project.projectId).toDomain()
        }

    override suspend fun readProjectPreviews(uid: String): List<ProjectPreview> =
        readProjects(uid).map { project ->
            ProjectPreview(
                id = project.id,
                client = clientSource.readClientById(project.clientId).toDomain(),
                type = project.type,
                name = project.name,
                color = project.color
            )
        }

    override suspend fun readTimer(uid: String): TimerData =
        source.readUserByUid(uid).timerData.toDomain()

    override suspend fun readTimerPreview(uid: String): TimerDataPreview {
        val timerData = source.readUserByUid(uid).timerData.toDomain()

        return TimerDataPreview(
            status = timerData.status,
            client = timerData.clientId?.let { clientId -> clientSource.readClientById(clientId).toDomain() },
            project = timerData.clientId?.let { clientId ->
                timerData.projectId?.let { projectId ->
                    clientSource.readProjectById(clientId, projectId).toDomain()
                }
            },
            description = timerData.description,
            startedAt = timerData.startedAt
        )
    }

    override suspend fun readEntryPreviews(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Page<TimerEntryPreview> {
        val page = source.readEntries(uid, startAfter, limit, endAt)

        return Page(
            data = page.data
                .map { it.toDomain() }
                .map { entry ->
                    TimerEntryPreview(
                        id = entry.id,
                        project = clientSource.readProjectById(entry.clientId, entry.projectId).toDomain(),
                        client = clientSource.readClientById(entry.clientId).toDomain(),
                        description = entry.description,
                        startedAt = entry.startedAt,
                        endedAt = entry.endedAt
                    )
                },
            isLast = page.isLast
        )
    }

    override suspend fun readEntryPreview(uid: String, entryId: String): TimerEntryPreview {
        val entry = source.readEntry(uid, entryId)
        return TimerEntryPreview(
            id = entry.id,
            project = clientSource.readProjectById(entry.clientId, entry.projectId).toDomain(),
            client = clientSource.readClientById(entry.clientId).toDomain(),
            description = entry.description,
            startedAt = entry.startedAt,
            endedAt = entry.endedAt
        )
    }

    override suspend fun createUser(uid: String): User =
        source.createUser(
            User(
                uid = uid,
                timerData = TimerData(
                    status = TimerStatus.Off,
                    clientId = null,
                    projectId = null,
                    description = null,
                    startedAt = null
                )
            )
        ).toDomain()

    override suspend fun updateTimer(uid: String, timerData: TimerData) {
        source.updateTimer(uid, timerData.toFirestore())
    }

    override suspend fun createEntry(uid: String, entry: NewTimerEntry): TimerEntry =
        source.createEntry(uid, entry)

    override suspend fun deleteEntry(uid: String, entryId: String) =
        source.deleteEntry(uid, entryId)

    override suspend fun readClients(uid: String): List<Client> =
        source.readClientIds(uid).map { clientId ->
            clientSource.readClientById(clientId).toDomain()
        }

    override suspend fun assignClientToUser(uid: String, clientId: String) =
        source.assignClientToUser(uid, clientId)

    override suspend fun assignProjectToUser(uid: String, clientId: String, projectId: String) =
        source.assignProjectToUser(uid, clientId, projectId)

    override suspend fun readTimerSummariesUseCase(uid: String): List<TimerSummary> {
        val localDateTime = Clock.System.now().toLocalDateTime(TimeZone.currentSystemDefault())
        val today = localDateTime.date
        val weekStart = today.minus(DatePeriod(days = today.dayOfWeek.ordinal))
        val weekEnd = weekStart.plus(DatePeriod(days = 7))

        val range = weekStart..weekEnd

        val entries = readEntries(
            uid = uid,
            startAfter = null,
            limit = null,
            endAt = weekStart.atStartOfDayIn(TimeZone.currentSystemDefault())
        ).data

        val totalToday = entries
            .filter { it.startedAt.toLocalDateTime(TimeZone.currentSystemDefault()).date == today }
            .sumOf { it.length().inWholeSeconds }

        val totalThisWeek = entries
            .filter { it.startedAt.toLocalDateTime(TimeZone.currentSystemDefault()).date in range }
            .sumOf { it.length().inWholeSeconds }

        val todaySummary = TimerSummary(TimerSummaryComponent.Today, totalToday)
        val weekSummary = TimerSummary(TimerSummaryComponent.ThisWeek, totalThisWeek)

        return listOf(todaySummary, weekSummary)
    }

    override suspend fun startTimer(uid: String, body: StartTimerBody) =
        source.startTimer(uid, body)

    override suspend fun stopTimer(uid: String) =
        source.stopTimer(uid)

    override suspend fun createEntryFromTimer(uid: String): TimerEntry? {
        val timerData = readUserByUid(uid).timerData

        if (timerData.status == TimerStatus.Off) return null

        if (timerData.startedAt == null) throw UserException.MissingStartDate(uid)

        if (timerData.clientId == null || timerData.projectId == null)
            throw UserException.MissingProject(uid)

        val newEntry = NewTimerEntry(
            clientId = timerData.clientId,
            projectId = timerData.projectId,
            description = timerData.description,
            startedAt = timerData.startedAt,
            endedAt = Clock.System.now()
        )

        return createEntry(uid, newEntry)
    }
}