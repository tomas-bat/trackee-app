package kmp.shared.base.error.util

import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.http.*
import kmp.shared.base.ErrorResult
import kmp.shared.base.Result
import kmp.shared.base.asErrorResult
import kmp.shared.base.error.domain.BackendError
import kmp.shared.base.error.domain.CommonError
import kmp.shared.base.error.infrastructure.ErrorDto

internal inline fun <R : Any> runCatchingAuthNetworkExceptions(block: () -> R): Result<R> =
    try {
        Result.Success(block())
    } catch (e: Throwable) {
        when (e::class.simpleName) { // Handle platform specific exceptions
            "UnknownHostException" -> Result.Error(CommonError.NoNetworkConnection(e))
            else -> Result.Error(e.asErrorResult)
        }
    }

internal suspend inline fun <R : Any> runCatchingCommonNetworkExceptions(block: () -> R): Result<R> {
    return try {
        Result.Success(block())
    } catch (e: ResponseException) {
        val body = try {
            e.response.body<ErrorDto>()
        } catch (t: NoTransformationFoundException) {
            val error = when (e.response.status) {
                HttpStatusCode.ServiceUnavailable -> BackendError.ServiceUnavailable(throwable = e)
                else -> CommonError.Unknown(e)
            }
            return Result.Error(error)
        }

        val error = when (body.type) {
            "Unauthorized" -> BackendError.NotAuthorized(e.response.toString(), e)
            "ProjectNotAssignedToUser" -> BackendError.ProjectNotAssignedToUser(body.message, e)
            "MissingProject" -> BackendError.MissingProject(body.message, e)
            "ProjectNotFound" -> BackendError.ProjectNotFound(body.message, e)
            "ClientNotFound" -> BackendError.ClientNotFound(body.message, e)
            "ClockifyProjectNotFound" -> BackendError.ClockifyProjectNotFound(body.message, e)
            "ClockifyInvalidApiKey" -> BackendError.ClockifyInvalidApiKey(e)
            "ClockifyUnknownError" -> BackendError.ClockifyUnknownError(e)
            "ClockifyWorkspaceNotFound" -> BackendError.ClockifyWorkspaceNotFound(body.message, e)
            else -> ErrorResult(message = body.message, throwable = e)
        }

        Result.Error(error)
    } catch (e: Throwable) {
        val error = when (e::class.simpleName) {
            "UnknownHostException" -> CommonError.NoNetworkConnection(e)
            "HttpRequestTimeoutException", "ConnectTimeoutException", "SocketTimeoutException" -> CommonError.Timeout(e)
            else -> handlePlatformError(e)
        }
        Result.Error(error)
    }
}

internal expect fun handlePlatformError(throwable: Throwable): ErrorResult
