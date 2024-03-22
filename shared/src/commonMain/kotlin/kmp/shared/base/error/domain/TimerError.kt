package kmp.shared.base.error.domain

import kmp.shared.base.ErrorResult

sealed class TimerError(
    message: String? = null,
    throwable: Throwable? = null
) : ErrorResult(message, throwable) {

    class ClientNotFound(message: String? = null, throwable: Throwable? = null) : TimerError(message, throwable)
    class ProjectNotFound(message: String? = null, throwable: Throwable? = null) : TimerError(message, throwable)
}