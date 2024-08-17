package app.trackee.backend.domain.repository

import app.trackee.backend.common.Page
import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectPreview
import app.trackee.backend.domain.model.timer.StartTimerBody
import app.trackee.backend.domain.model.timer.TimerData
import app.trackee.backend.domain.model.timer.TimerDataPreview
import app.trackee.backend.domain.model.timer.TimerSummary
import app.trackee.backend.domain.model.user.User
import kotlinx.datetime.Instant

interface UserRepository {
    suspend fun readUserByUid(uid: String): User

    suspend fun deleteUser(uid: String)

    suspend fun readEntries(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Page<TimerEntry>

    suspend fun readEntryById(uid: String, entryId: String): TimerEntry

    suspend fun readProjects(uid: String): List<Project>

    suspend fun readProjectPreviews(uid: String): List<ProjectPreview>

    suspend fun readTimer(uid: String): TimerData

    suspend fun readTimerPreview(uid: String): TimerDataPreview

    suspend fun readEntryPreviews(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Page<TimerEntryPreview>

    suspend fun readEntryPreview(
        uid: String,
        entryId: String
    ): TimerEntryPreview

    suspend fun createUser(uid: String): User

    suspend fun updateTimer(uid: String, timerData: TimerData)

    suspend fun createEntry(uid: String, entry: NewTimerEntry): TimerEntry

    suspend fun updateEntry(uid: String, entry: TimerEntry): TimerEntry

    suspend fun addClockifyDataToEntry(
        uid: String,
        entryId: String,
        clockifyEntryId: String,
        clockifyWorkspaceId: String
    )

    suspend fun deleteEntry(uid: String, entryId: String)

    suspend fun readClients(uid: String): List<Client>

    suspend fun assignClientToUser(uid: String, clientId: String)

    suspend fun assignProjectToUser(uid: String, clientId: String, projectId: String)

    suspend fun readTimerSummariesUseCase(uid: String): List<TimerSummary>

    suspend fun startTimer(uid: String, body: StartTimerBody)

    suspend fun stopTimer(uid: String)

    suspend fun createEntryFromTimer(uid: String): TimerEntry?
}