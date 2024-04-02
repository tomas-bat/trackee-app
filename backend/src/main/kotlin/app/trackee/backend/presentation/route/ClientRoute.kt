package app.trackee.backend.presentation.route.user

import app.trackee.backend.config.exceptions.ClientException
import app.trackee.backend.domain.repository.ClientRepository
import app.trackee.backend.presentation.model.client.ClientDto
import app.trackee.backend.presentation.model.client.NewClientDto
import app.trackee.backend.presentation.model.client.toDomain
import app.trackee.backend.presentation.model.client.toDto
import app.trackee.backend.presentation.model.project.toDto
import com.google.firebase.auth.FirebaseAuth
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import org.koin.ktor.ext.inject

fun Routing.clientRoute() {
    val auth by inject<FirebaseAuth>()
    val clientRepository by inject<ClientRepository>()

    authenticate {
        route("/clients") {
            post<NewClientDto> { body ->
                clientRepository.createClient(body.toDomain())

                call.respond(HttpStatusCode.Created)
            }

            route("/{clientId}") {
                get {
                    val clientId: String by call.parameters
                    val clientDto = clientRepository.readClientById(clientId).toDto()

                    call.respond(HttpStatusCode.OK, clientDto)
                }

                put<ClientDto> { body ->
                    val clientId: String by call.parameters

                    if (clientId != body.id) throw ClientException.ClientIdMismatch(clientId, body.id)

                    clientRepository.updateClient(body.toDomain())

                    call.respond(HttpStatusCode.OK)
                }

                delete {
                    val clientId: String by call.parameters
                    clientRepository.deleteClient(clientId)

                    call.respond(HttpStatusCode.OK)
                }

                route("/projects") {
                    get {
                        val clientId: String by call.parameters
                        val projects = clientRepository
                            .readProjectsForClient(clientId)
                            .map { it.toDto() }

                        call.respond(HttpStatusCode.OK, projects)
                    }

                    route("/{projectId}") {
                        get {
                            val clientId: String by call.parameters
                            val projectId: String by call.parameters
                            val project = clientRepository.readProject(clientId, projectId).toDto()

                            call.respond(HttpStatusCode.OK, project)
                        }
                    }
                }
            }
        }
    }
}