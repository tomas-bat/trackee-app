package app.trackee.backend.plugins

import app.trackee.backend.config.exceptions.BaseException
import app.trackee.backend.domain.model.error.ErrorDto
import app.trackee.backend.presentation.route.projectRoute
import app.trackee.backend.presentation.route.user.clientRoute
import app.trackee.backend.presentation.route.user.userRoute
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.io.File

fun Application.configureRouting(isDebug: Boolean) {
    install(StatusPages) {
        exception<BaseException> { call, baseException ->
            call.respond(
                status = baseException.code,
                message = baseException.toDto(isDebug)
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
            call.respondText("Hello World!")
        }
        get("/.well-known/apple-app-site-association") {
            val url = this.javaClass.classLoader.getResource("apple-app-site-association")
            val file = File(url.file)
            call.respondFile(file)
        }
        userRoute()
        clientRoute()
        projectRoute()
    }
}

private fun BaseException.toDto(isDebug: Boolean) = ErrorDto(
    type = this::class.simpleName!!,
    message = publicMessage,
    params = params,
    debugMessage = debugMessage?.takeIf { isDebug }
)
