package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class ClientException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class ClientNotFound(id: String?) : ClientException(
        publicMessage = buildString {
            append("Client ")
            if (id != null) append("with ID $id ")
            append("does not exist")
        }
    )

    class ProjectNotFound(clientId: String?, projectId: String?) : ClientException(
        publicMessage = buildString {
            append("Project ")
            if (projectId != null) append("with ID $projectId ")
            if (clientId != null) append("with clientID $clientId ")
            append("does not exist")
        }
    )
}