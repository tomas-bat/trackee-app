package app.trackee.backend

import app.trackee.backend.config.firebase.firebaseModule
import app.trackee.backend.plugins.configureHTTP
import app.trackee.backend.plugins.configureRouting
import app.trackee.backend.plugins.configureSecurity
import app.trackee.backend.plugins.configureSerialization
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import org.koin.ktor.plugin.Koin

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

fun Application.module() {

    install(Koin) {
        modules(
            mainBackendModule(true),
            firebaseModule
        )
    }

    configureHTTP()
    configureSecurity()
    configureSerialization()
    //configureDatabases()
    configureRouting()
}
