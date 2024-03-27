package app.trackee.backend.plugins

import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.config.firebase.UserPrincipal
import app.trackee.backend.config.firebase.firebase
import app.trackee.backend.domain.repository.UserRepository
import com.google.firebase.auth.FirebaseAuth
import io.ktor.server.application.*
import io.ktor.server.auth.*
import org.koin.ktor.ext.inject


fun Application.configureSecurity() {
    val firebaseAuth by inject<FirebaseAuth>()
    val userRepository by inject<UserRepository>()

    authentication {
        firebase {
            firebase = firebaseAuth
            mapPrincipal {userRecord ->
                userRecord.uid

                val principal = try {
                    val user = userRepository.readUserByUid(userRecord.uid)
                    UserPrincipal(user)
                } catch(e: UserException.UserNotFound) {
                    val user = userRepository.createUser(userRecord.uid)
                    UserPrincipal(user)
                }

                principal
            }
        }
    }
}
