package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class ClockifyException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class ClockifyProjectNotFound(projectId: String?, projectName: String?) : ClockifyException(
        publicMessage = buildString {
            if (projectName != null) append(projectName)
            if (projectId != null) append(" ($projectId)")
        }
    )

    class InvalidApiKey(message: String? = null) : ClockifyException(
        publicMessage = "Invalid API key",
        debugMessage = message
    )

    class Unknown(message: String? = null) : ClockifyException(
        debugMessage = message
    )
}