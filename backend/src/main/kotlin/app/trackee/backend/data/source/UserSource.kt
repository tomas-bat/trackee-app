package app.trackee.backend.data.source

import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.project.IdentifiableProject
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.user.FirestoreUser

internal interface UserSource {
    suspend fun readUserByUid(uid: String): FirestoreUser

    suspend fun readEntries(uid: String): List<FirestoreTimerEntry>

    suspend fun readProjectIds(uid: String): List<IdentifiableProject>

    suspend fun createUser(user: User): FirestoreUser

    suspend fun updateTimer(uid: String, timerData: FirestoreTimerData)

    suspend fun createEntry(uid: String, entry: NewTimerEntry)

    suspend fun deleteEntry(uid: String, entryId: String)

    suspend fun readClientIds(uid: String): List<String>

    suspend fun assignClientToUser(uid: String, clientId: String)
}