package app.trackee.backend

import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.data.repository.UserRepositoryImpl
import io.ktor.client.*
import io.ktor.client.engine.okhttp.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json
import org.koin.dsl.module
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind

internal fun mainBackendModule(isDebug: Boolean) = module(createdAtStart = true) {
    single { ApplicationConfig(isDebug) }
    single { buildHttpClient() }

    singleOf(::UserRepositoryImpl) bind UserRepository::class
}

private fun buildHttpClient() = HttpClient(OkHttp) {
    followRedirects = false
    expectSuccess = true // throw exception when response is not 2xx

    install(ContentNegotiation) {
        json(
            Json {
                useAlternativeNames = false
                ignoreUnknownKeys = true
            }
        )
    }

    install(HttpTimeout) {
        socketTimeoutMillis = 2_000L
        requestTimeoutMillis = 2_000L
        connectTimeoutMillis = 2_000L
    }
}