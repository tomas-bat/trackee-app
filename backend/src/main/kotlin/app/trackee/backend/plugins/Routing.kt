package app.trackee.backend.plugins

import app.trackee.backend.config.exceptions.BaseException
import app.trackee.backend.presentation.model.error.ErrorDto
import app.trackee.backend.presentation.route.integrationRoute
import app.trackee.backend.presentation.route.projectRoute
import app.trackee.backend.presentation.route.user.clientRoute
import app.trackee.backend.presentation.route.user.userRoute
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRouting(isDebug: Boolean) {
    install(StatusPages) {
        exception<BaseException> { call, baseException ->
            call.respond(
                status = baseException.code,
                baseException.toDto(isDebug)
            )
        }

        exception<Throwable> { call, cause ->
            call.respond(
                status = HttpStatusCode.InternalServerError,
                message = ErrorDto(
                    type = "InternalError",
                    message = "Internal Server Error",
                    debugMessage = if (isDebug) cause.message else null
                )
            )
        }
    }
    routing {
        get("/") {
            call.respondRedirect("openapi")
        }
        staticResources("/static", "static")
        staticResources(".well-known/apple-app-site-association", "apple-app-site-association")
        userRoute()
        clientRoute()
        projectRoute()
        integrationRoute()
    }
}

fun BaseException.toDto(isDebug: Boolean) = ErrorDto(
    type = this::class.simpleName!!,
    message = publicMessage,
    params = params,
    debugMessage = debugMessage?.takeIf { isDebug }
)
