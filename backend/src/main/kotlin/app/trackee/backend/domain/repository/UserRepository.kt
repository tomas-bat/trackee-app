package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.user.User

interface UserRepository {
    suspend fun readUserByUid(uid: String): User
}