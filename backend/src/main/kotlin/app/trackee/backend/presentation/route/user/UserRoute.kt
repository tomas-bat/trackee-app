package app.trackee.backend.presentation.route.user

import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.presentation.model.entry.toDto
import app.trackee.backend.presentation.model.project.toDto
import app.trackee.backend.presentation.model.timer.toDto
import app.trackee.backend.presentation.model.user.toDto
import app.trackee.backend.presentation.util.requireUserPrincipal
import com.google.firebase.auth.FirebaseAuth
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import org.koin.ktor.ext.inject

fun Routing.userRoute() {
    val auth by inject<FirebaseAuth>()
    val userRepository by inject<UserRepository>()

    authenticate {
        route("/users") {
            route("/{uid}") {
                get {
                    val uid: String by call.parameters
                    val userDto = userRepository.readUserByUid(uid).toDto()

                    call.respond(HttpStatusCode.OK, userDto)
                }

                get("/entries") {
                    val uid: String by call.parameters
                    val entryDtos = userRepository.readEntries(uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, entryDtos)
                }
            }
        }

        route("/user") {
            route("/entries") {
                get {
                    val user = call.requireUserPrincipal().user
                    val entryDtos = userRepository.readEntries(user.uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, entryDtos)
                }

                get("/previews") {
                    val user = call.requireUserPrincipal().user
                    val entryPreviewDtos = userRepository.readEntryPreviews(user.uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, entryPreviewDtos)
                }
            }

            route("/timer") {
                get {
                    val user = call.requireUserPrincipal().user
                    val timerDataDto = userRepository.readTimer(user.uid).toDto()

                    call.respond(HttpStatusCode.OK, timerDataDto)
                }

                get("/preview") {
                    val user = call.requireUserPrincipal().user
                    val timerDataPreviewDto = userRepository.readTimerPreview(user.uid).toDto()

                    call.respond(HttpStatusCode.OK, timerDataPreviewDto)
                }
            }

            get {
                val userDto = call.requireUserPrincipal().user.toDto()
                call.respond(HttpStatusCode.OK, userDto)
            }

            route("/projects") {
                get {
                    val user = call.requireUserPrincipal().user
                    val projectDtos = userRepository.readProjects(user.uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, projectDtos)
                }

                get("/previews") {
                    val user = call.requireUserPrincipal().user
                    val projectPreviewDtos = userRepository.readProjectPreviews(user.uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, projectPreviewDtos)
                }
            }
        }
    }
}