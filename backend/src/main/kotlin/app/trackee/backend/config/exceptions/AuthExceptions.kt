package app.trackee.backend.config.exceptions

import io.ktor.http.*

sealed class AuthException(
    publicMessage: String? = null,
    code: HttpStatusCode,
    debugMessage: String? = null
) : BaseException(publicMessage, code, debugMessage) {

    class InvalidToken(exception: Exception) : AuthException(
        publicMessage = "Invalid authentication token",
        code = HttpStatusCode.BadRequest,
        debugMessage = "Invalid auth token header value. Message: ${exception.message}"
    )

    object Unauthorized : AuthException(
        publicMessage = "Insufficient authorization",
        code = HttpStatusCode.Unauthorized
    )

}