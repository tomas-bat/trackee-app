package kmp.shared.base.error.util

import io.ktor.client.call.*
import io.ktor.client.plugins.*
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

internal suspend inline fun <R : Any> runCatchingCommonNetworkExceptions(block: () -> R): Result<R> =
    try {
        Result.Success(block())
    } catch (e: ResponseException) {
        val body = e.response.body<ErrorDto>()

        when (body.type) {
            "Unauthorized" -> Result.Error(
                BackendError.NotAuthorized(e.response.toString(), e),
            )

            "ProjectNotAssignedToUser" -> Result.Error(
                BackendError.ProjectNotAssignedToUser(e.message, e)
            )

            "MissingProject" -> Result.Error(
                BackendError.MissingProject(e.message, e)
            )

            else -> Result.Error(
                ErrorResult(
                    message = body.message,
                    throwable = e
                )
            )
        }
    } catch (e: Throwable) {
        Result.Error(handlePlatformError(e))
    }

internal expect fun handlePlatformError(throwable: Throwable): ErrorResult
