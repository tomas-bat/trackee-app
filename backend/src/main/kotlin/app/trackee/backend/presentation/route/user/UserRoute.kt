package app.trackee.backend.presentation.route.user

import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.presentation.model.user.toDto
import app.trackee.backend.presentation.util.requireUserPrincipal
import com.google.firebase.auth.FirebaseAuth
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import org.koin.ktor.ext.inject

fun Routing.userRoute() {
    val auth by inject<FirebaseAuth>()
    val userRepository by inject<UserRepository>()

//    authenticate {
        route("/users") {
            route("current") {
                get {
                    call.respond(HttpStatusCode.OK, call.requireUserPrincipal().user)
                }
            }

            get("/{uid}") {
                val uid: String by call.parameters
                val userDto = userRepository.readUserByUid(uid).toDto()

                call.respond(HttpStatusCode.OK, userDto)
            }


        }
//    }
}