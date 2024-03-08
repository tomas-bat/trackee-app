package app.trackee.backend.data.repository

import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.domain.repository.UserRepository

class UserRepositoryImpl(
    private val source: UserSource
) : UserRepository {
    override suspend fun readUserByUid(uid: String): User =
        source.readUserByUid(uid)
}