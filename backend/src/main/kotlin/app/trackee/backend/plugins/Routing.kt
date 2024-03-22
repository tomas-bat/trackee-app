package app.trackee.backend.plugins

import app.trackee.backend.presentation.route.user.clientRoute
import app.trackee.backend.presentation.route.user.userRoute
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.io.File

fun Application.configureRouting() {
    install(StatusPages) {
        exception<Throwable> { call, cause ->
            call.respondText(text = "500: $cause" , status = HttpStatusCode.InternalServerError)
        }
    }
    routing {
        get("/") {
            call.respondText("Hello World!")
        }
        get("/.well-known/apple-app-site-association") {
            call.respondFile(File("src/main/resources/apple-app-site-association"))
        }
        userRoute()
        clientRoute()
    }
}
