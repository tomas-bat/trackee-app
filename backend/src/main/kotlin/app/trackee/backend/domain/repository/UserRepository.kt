package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.entry.TimerEntryPreview
import app.trackee.backend.domain.model.project.Project
import app.trackee.backend.domain.model.project.ProjectPreview
import app.trackee.backend.domain.model.timer.TimerData
import app.trackee.backend.domain.model.timer.TimerDataPreview
import app.trackee.backend.domain.model.user.User

interface UserRepository {
    suspend fun readUserByUid(uid: String): User

    suspend fun readEntries(uid: String): List<TimerEntry>

    suspend fun readProjects(uid: String): List<Project>

    suspend fun readProjectPreviews(uid: String): List<ProjectPreview>

    suspend fun readTimer(uid: String): TimerData

    suspend fun readTimerPreview(uid: String): TimerDataPreview

    suspend fun readEntryPreviews(uid: String): List<TimerEntryPreview>

    suspend fun createUser(uid: String): User

    suspend fun updateTimer(uid: String, timerData: TimerData)

    suspend fun createEntry(uid: String, entry: NewTimerEntry)

    suspend fun deleteEntry(uid: String, entryId: String)
}