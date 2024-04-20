package app.trackee.backend.presentation.route

import app.trackee.backend.config.exceptions.IntegrationException
import app.trackee.backend.domain.repository.IntegrationRepository
import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.presentation.model.integration.IntegrationDto
import app.trackee.backend.presentation.model.integration.NewIntegrationDto
import app.trackee.backend.presentation.model.integration.toDomain
import app.trackee.backend.presentation.model.integration.toDto
import app.trackee.backend.presentation.util.requireUserPrincipal
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import kotlinx.datetime.toInstant
import org.koin.ktor.ext.inject

fun Routing.integrationRoute() {
    val repository: IntegrationRepository by inject<IntegrationRepository>()
    val userRepository: UserRepository by inject<UserRepository>()

    authenticate {
        route("/integrations") {
            route("/{integrationId}") {
                get {
                    val user = call.requireUserPrincipal().user
                    val integrationId: String by call.parameters

                    val integration = repository.readIntegration(user.uid, integrationId)

                    call.respond(HttpStatusCode.OK, integration.toDto())
                }

                put<IntegrationDto> { body ->
                    val user = call.requireUserPrincipal().user
                    val integrationId: String by call.parameters

                    if (integrationId != body.id)
                        throw IntegrationException.IntegrationIDMismatch(user.uid, body.id, integrationId)

                    repository.updateIntegration(user.uid, body.toDomain())

                    call.respond(HttpStatusCode.OK)
                }

                delete {
                    val user = call.requireUserPrincipal().user
                    val integrationId: String by call.parameters
                    repository.deleteIntegration(user.uid, integrationId)

                    call.respond(HttpStatusCode.OK)
                }
            }

            get {
                val user = call.requireUserPrincipal().user
                val integrations = repository.readIntegrations(user.uid)

                call.respond(HttpStatusCode.OK, integrations.map { it.toDto() })
            }

            post<NewIntegrationDto>("/add") { body ->
                val user = call.requireUserPrincipal().user

                repository.createIntegration(user.uid, body.toDomain())

                call.respond(HttpStatusCode.Created)
            }

            route("/csv") {
                get {
                    val user = call.requireUserPrincipal().user
                    val from = call.request.queryParameters["from"]
                    val to = call.request.queryParameters["to"]

                    val entries = userRepository.readEntryPreviews(
                        uid = user.uid,
                        startAfter = to?.toInstant(),
                        limit = null,
                        endAt = from?.toInstant()
                    ).data
                    val csv = repository.readCsv(entries.reversed())

                    call.respondFile(csv)

                    repository.deleteTempCsvFile(csv.name)
                }
            }
        }
    }
}