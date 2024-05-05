package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class ClockifyException(
    publicMessage: String? = null,
    debugMessage: String? = null,
    code: HttpStatusCode = HttpStatusCode.BadRequest
) : BaseException(publicMessage, code, debugMessage) {

    class ProjectNotFound(projectId: String?, projectName: String?) : ClockifyException(
        publicMessage = buildString {
            append("Project ")
            if (projectName != null) append("$projectName ")
            if (projectId != null) append("id=$projectId ")
            append("was not found")
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