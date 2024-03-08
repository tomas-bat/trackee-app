package app.trackee.backend.data.source

import app.trackee.backend.domain.model.user.User

interface UserSource {
    suspend fun readUserByUid(uid: String): User
}