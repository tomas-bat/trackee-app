package app.trackee.backend.data.source

import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntryWithId
import app.trackee.backend.infrastructure.model.user.FirestoreUser

internal interface UserSource {
    suspend fun readUserByUid(uid: String): FirestoreUser

    suspend fun readEntries(uid: String): List<FirestoreTimerEntryWithId>
}