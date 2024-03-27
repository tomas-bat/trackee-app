package app.trackee.backend.data.source

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.project.IdentifiableProject
import app.trackee.backend.infrastructure.model.user.FirestoreUser

internal interface UserSource {
    suspend fun readUserByUid(uid: String): FirestoreUser

    suspend fun readEntries(uid: String): List<FirestoreTimerEntry>

    suspend fun readProjectIds(uid: String): List<IdentifiableProject>

    suspend fun createUser(user: User): FirestoreUser
}