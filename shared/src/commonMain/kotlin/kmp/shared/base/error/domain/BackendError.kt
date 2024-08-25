package kmp.shared.base.error.domain

import kmp.shared.base.ErrorResult

/**
 * Error type used when handling responses from backend
 * @param throwable optional [Throwable] parameter used for debugging or crash reporting
 */
sealed class BackendError(
    throwable: Throwable? = null,
    responseMessage: String? = null,
) : ErrorResult(throwable = throwable, message = responseMessage) {

    class NotAuthorized(
        responseMessage: String?,
        throwable: Throwable? = null,
    ) : BackendError(throwable, responseMessage)

    class ProjectNotAssignedToUser(
        responseMessage: String? = null,
        throwable: Throwable? = null
    ) : BackendError(throwable, responseMessage)

    class MissingProject(
        responseMessage: String?,
        throwable: Throwable? = null,
    ) : BackendError(throwable, responseMessage)

    class MissingStartDate(
        responseMessage: String?,
        throwable: Throwable? = null,
    ) : BackendError(throwable, responseMessage)

    class ProjectNotFound(
        responseMessage: String? = null,
        throwable: Throwable? = null
    ) : BackendError(throwable, responseMessage)

    class ClientNotFound(
        responseMessage: String? = null,
        throwable: Throwable? = null
    ) : BackendError(throwable, responseMessage)

    data class ClockifyProjectNotFound(
        val projectName: String? = null,
        override var throwable: Throwable? = null
    ) : BackendError(throwable, projectName)

    class ClockifyInvalidApiKey(
        throwable: Throwable? = null
    ) : BackendError(throwable, null)

    class ClockifyUnknownError(
        throwable: Throwable? = null
    ) : BackendError(throwable, null)

    data class ClockifyWorkspaceNotFound(
        val workspaceName: String? = null,
        override var throwable: Throwable? = null
    ) : BackendError(throwable, workspaceName)

    class ServiceUnavailable(
        responseMessage: String? = null,
        throwable: Throwable? = null
    ) : BackendError(throwable, responseMessage)
}
