package kmp.shared.base.error.domain

import kmp.shared.base.ErrorResult

sealed class ProfileError(
    message: String? = null,
    throwable: Throwable? = null
) : ErrorResult(message, throwable) {

    class FailedToCreateClient(message: String? = null, throwable: Throwable? = null) : ProfileError(message, throwable)

    class FailedToCreateProject(message: String? = null, throwable: Throwable? = null) : ProfileError(message, throwable)
}