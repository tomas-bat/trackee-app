package app.trackee.backend

import app.trackee.backend.config.firebase.firebaseModule
import app.trackee.backend.plugins.configureHTTP
import app.trackee.backend.plugins.configureRouting
import app.trackee.backend.plugins.configureSecurity
import app.trackee.backend.plugins.configureSerialization
import io.ktor.server.application.*
import org.koin.ktor.plugin.Koin

fun main(args: Array<String>) = io.ktor.server.netty.EngineMain.main(args)
fun Application.module() {
    val env = environment.config
        .property("project.environment")
        .getString()

    val isDebug = env != "prod"

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
    configureRouting(isDebug)
}
