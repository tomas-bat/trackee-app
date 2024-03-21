package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.user.User

interface UserRepository {
    suspend fun readUserByUid(uid: String): User

    suspend fun readEntries(uid: String): List<TimerEntry>
}