package kmp.shared.base.error.domain

import kmp.shared.base.ErrorResult

sealed class AuthError(
    message: String? = null,
    throwable: Throwable? = null,
) : ErrorResult(message, throwable) {

    class InvalidLoginCredentials(throwable: Throwable? = null) : AuthError(null, throwable)
    class EmailAlreadyExist(throwable: Throwable? = null) : AuthError(null, throwable)
    class EmptyField : AuthError()
    class PasswordsDontMatch : AuthError()
    class NoAccessToken : AuthError()
    class NoCurrentUser : AuthError()
    class InvalidEmail: AuthError()
    class WeakPassword: AuthError()
    class ExternalError(message: String? = null) : AuthError(message = message)
    class ExternalFlowCancelled : AuthError()
}
