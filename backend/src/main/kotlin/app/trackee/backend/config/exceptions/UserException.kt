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

    class ProjectNotAssignedToUser(uid: String?, clientId: String?, projectId: String?): UserException(
        publicMessage = buildString {
            append("Project ")
            if (clientId != null && projectId != null) append("(clientId=${clientId}, projectId=${projectId}) ")
            append("is not assigned to user")
            if (uid != null) append(" with uid=${uid})")
        }
    )
}