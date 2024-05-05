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

    class ClockifyInvalidApiKey(message: String? = null) : ClockifyException(
        publicMessage = "Invalid API key",
        debugMessage = message
    )

    class ClockifyUnknownError(message: String? = null) : ClockifyException(
        publicMessage = message
    )

    class ClockifyWorkspaceNotFound(workspaceName: String? = null) : ClockifyException(
        publicMessage = workspaceName
    )
}