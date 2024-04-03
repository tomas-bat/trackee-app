package app.trackee.backend.presentation.route

import app.trackee.backend.config.exceptions.ProjectException
import app.trackee.backend.domain.repository.ProjectRepository
import app.trackee.backend.presentation.model.project.NewProjectDto
import app.trackee.backend.presentation.model.project.ProjectDto
import app.trackee.backend.presentation.model.project.toDomain
import com.google.firebase.auth.FirebaseAuth
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import org.koin.ktor.ext.inject

fun Routing.projectRoute() {
    val auth by inject<FirebaseAuth>()
    val projectRepository by inject<ProjectRepository>()

    authenticate {
        route("/projects") {
            post<NewProjectDto> { body ->
                projectRepository.createProject(body.toDomain())

                call.respond(HttpStatusCode.Created)
            }

            route("/{projectId}") {
                put<ProjectDto> { body ->
                    val projectId: String by call.parameters

                    if (projectId != body.id) throw ProjectException.ProjectIdMismatch(projectId, body.id)

                    projectRepository.updateProject(body.toDomain())

                    call.respond(HttpStatusCode.OK)
                }

                delete {
                    val projectId: String by call.parameters
                    val clientId: String by call.request.queryParameters
                    projectRepository.deleteProject(clientId, projectId)

                    call.respond(HttpStatusCode.OK)
                }
            }
        }
    }
}