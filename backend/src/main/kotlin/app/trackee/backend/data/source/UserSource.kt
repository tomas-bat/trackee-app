package app.trackee.backend.data.source

import app.trackee.backend.common.Page
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.project.IdentifiableProject
import app.trackee.backend.domain.model.timer.StartTimerBody
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import kotlinx.datetime.Instant

internal interface UserSource {
    suspend fun readUserByUid(uid: String): FirestoreUser

    suspend fun deleteUser(uid: String)

    suspend fun readEntries(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Page<FirestoreTimerEntry>

    suspend fun readEntry(uid: String, entryId: String): TimerEntry

    suspend fun readProjectIds(uid: String): List<IdentifiableProject>

    suspend fun createUser(user: User): FirestoreUser

    suspend fun updateTimer(uid: String, timerData: FirestoreTimerData)

    suspend fun createEntry(uid: String, entry: NewTimerEntry): TimerEntry

    suspend fun deleteEntry(uid: String, entryId: String)

    suspend fun readClientIds(uid: String): List<String>

    suspend fun assignClientToUser(uid: String, clientId: String)

    suspend fun assignProjectToUser(uid: String, clientId: String, projectId: String)

    suspend fun startTimer(uid: String, body: StartTimerBody)

    suspend fun stopTimer(uid: String)
}