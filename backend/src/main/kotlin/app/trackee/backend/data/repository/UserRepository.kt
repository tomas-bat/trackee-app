package app.trackee.backend.data.repository

import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.infrastructure.model.entry.toDomain
import app.trackee.backend.infrastructure.model.user.toDomain

internal class UserRepositoryImpl(
    private val source: UserSource
) : UserRepository {
    override suspend fun readUserByUid(uid: String): User =
        source.readUserByUid(uid).toDomain(uid)

    override suspend fun readEntries(uid: String): List<TimerEntry> =
        source.readEntries(uid).map { it.toDomain() }
}