package app.trackee.backend.config.exceptions

import io.ktor.http.*

abstract class BaseException(
    val publicMessage: String? = null,
    val code: HttpStatusCode = HttpStatusCode.BadRequest,
    open val debugMessage: String? = null,
    val params: Map<String, String> = emptyMap(),
) : Exception(publicMessage)