package kmp.shared.network

import io.ktor.client.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kmp.shared.base.util.extension.getOrNull
import kmp.shared.common.provider.AppInfoProvider
import kmp.shared.common.provider.AuthProvider
import kmp.shared.configuration.domain.configuration
import kotlinx.serialization.json.Json
import kotlin.native.concurrent.ThreadLocal
import co.touchlab.kermit.Logger.Companion as KermitLogger

@ThreadLocal
private val globalJson = Json {
    useAlternativeNames = false
    ignoreUnknownKeys = true
}

object NetworkClient {
    object Ktor {
        fun getClient(
            appInfoProvider: AppInfoProvider,
            authProvider: AuthProvider
        ) = HttpClient {
            followRedirects = false
            expectSuccess = true

            install(ContentNegotiation) {
                json(globalJson)
            }

            install(HttpTimeout) {
                socketTimeoutMillis = 20_000L
                requestTimeoutMillis = 20_000L
                connectTimeoutMillis = 20_000L
            }

            defaultRequest {
                contentType(ContentType.Application.Json)

                url(
                    scheme = URLProtocol.HTTPS.name,
                    host = appInfoProvider.environment.configuration.host
                )

//                url(
//                    scheme = URLProtocol.HTTP.name,
//                    host = "0.0.0.0",
//                    port = 8080,
//                )
//
//                url(
//                    scheme = URLProtocol.HTTP.name,
//                    host = "192.168.0.147",
//                    port = 8080,
//                )
            }

            install("AuthInterceptor") {
                sendPipeline.intercept(HttpSendPipeline.State) {
                    val token = authProvider.readAccessToken().getOrNull()
                    if (token != null) {
                        context.header(HttpHeaders.Authorization, "Bearer $token")
                    }
                }
            }

            install(Logging) {
                logger = object : Logger {
                    override fun log(message: String) {
                        KermitLogger.d(tag = "Ktor") { message }
                    }
                }
            }

            HttpResponseValidator {
                handleResponseExceptionWithRequest { exception, request ->
                    val clientException = exception as? ClientRequestException ?: return@handleResponseExceptionWithRequest
                    val exceptionResponse = clientException.response
                    if (exceptionResponse.status == HttpStatusCode.Unauthorized) {
                        appInfoProvider.logout()
                    }
                }
            }
        }
    }
}