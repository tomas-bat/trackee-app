package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class UserException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class UserNotFound(uid: String?): UserException(
        publicMessage = buildString {
            append("User ")
            if (uid != null) append("with UID $uid ")
            append("does not exist")
        }
    )
}