package kmp.shared.base.error.domain

import kmp.shared.base.ErrorResult

sealed class AuthError(
    message: String? = null,
    throwable: Throwable? = null,
) : ErrorResult(message, throwable) {

    class InvalidLoginCredentials(throwable: Throwable? = null) : AuthError(null, throwable)
    class EmailAlreadyExist(throwable: Throwable? = null) : AuthError(null, throwable)

    class ProviderLoginFailed(throwable: Throwable? = null) : AuthError(null, throwable) {
        constructor() : this(null)
    }

    class CredentialLoginFailed(throwable: Throwable? = null) : AuthError(null, throwable) {
        constructor() : this(null)
    }
}
