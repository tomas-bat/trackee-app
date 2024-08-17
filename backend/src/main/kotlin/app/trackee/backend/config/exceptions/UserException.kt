package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class UserException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class UserNotFound(uid: String?) : UserException(
        publicMessage = buildString {
            append("User ")
            if (uid != null) append("with UID $uid ")
            append("does not exist")
        }
    )

    class ProjectNotAssignedToUser(uid: String?, clientId: String?, projectId: String?) : UserException(
        publicMessage = buildString {
            append("Project ")
            if (clientId != null && projectId != null) append("(clientId=${clientId}, projectId=${projectId}) ")
            append("is not assigned to user")
            if (uid != null) append(" with uid=${uid})")
        }
    )

    class MissingProject(uid: String?) : UserException(
        publicMessage = buildString {
            append("Missing selected project")
            if (uid != null) append(" for uid=${uid}")
        }
    )

    class MissingStartDate(uid: String?) : UserException(
        publicMessage = buildString {
            append("Missing start date")
            if (uid != null) append(" for uid=${uid}")
        }
    )

    class FailedToGetCreatedEntry(uid: String?) : UserException(
        publicMessage = buildString {
            append("Failed to get created entry")
            if (uid != null) append(" for uid=${uid}")
        }
    )

    class FailedToGetUpdatedEntry(entryId: String?, uid: String?) : UserException(
        publicMessage = buildString {
            append("Failed to get updated entry")
            if (entryId != null) append(" with entryId=$entryId")
            if (uid != null) append(" for uid=${uid}")
        }
    )

    class EntryNotFound(uid: String?, entryId: String?) : UserException(
        publicMessage = buildString {
            append("Entry ")
            if (entryId != null) append("(entryId=$entryId) ")
            if (uid != null) append("(uid=$uid) ")
            append("not found")
        }
    )

    class EntryIdMismatch(uid: String?, entryId: String?, bodyId: String?) : UserException(
        publicMessage = buildString {
            append("Entry ID mismatch")
            if (uid != null) append(", uid=$uid")
            if (entryId != null) append(", entryId=$entryId")
            if (bodyId != null) append(", bodyId=$bodyId")
        }
    )
}