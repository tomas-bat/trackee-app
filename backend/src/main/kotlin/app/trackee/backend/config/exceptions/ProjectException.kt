package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class ProjectException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class ProjectNotFound(clientId: String?, projectId: String?) : ClientException(
        publicMessage = buildString {
            append("Project ")
            if (projectId != null) append("with ID $projectId ")
            if (clientId != null) append("with clientID $clientId ")
            append("does not exist")
        }
    )

    class ProjectIdMismatch(first: String?, second: String?) : ClientException(
        publicMessage = buildString {
            append("Project ID and document ID don't match")
            if (first != null && second != null) append(" (${first} != ${second})")
        }
    )
}