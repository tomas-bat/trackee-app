package app.trackee.backend.config.firebase

import app.trackee.backend.config.exceptions.AuthException
import app.trackee.backend.config.util.await
import app.trackee.backend.domain.model.user.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseAuthException
import com.google.firebase.auth.UserRecord
import io.ktor.http.auth.*
import io.ktor.server.auth.*

class FirebaseAuthProvider(config: Config) : AuthenticationProvider(config) {

    private val firebase = requireNotNull(config.firebase)
    private val mapPrincipal = requireNotNull(config.mapPrincipal)

    override suspend fun onAuthenticate(context: AuthenticationContext) {
        val authHeader = context.call.request.parseAuthorizationHeader() as? HttpAuthHeader.Single ?: throw AuthException.Unauthorized

        val token = try {
            firebase.verifyIdTokenAsync(authHeader.blob).await()
        } catch (e: FirebaseAuthException) {
            throw AuthException.InvalidToken(e)
        }

        val user = firebase.getUserAsync(token.uid).await()

        context.principal(FirebasePrincipal(user))

        val principal = context.mapPrincipal(user)
        if (principal != null) context.principal(principal)
    }

    class Config internal constructor(name: String?) : AuthenticationProvider.Config(name) {
        var firebase: FirebaseAuth? = null

        internal var mapPrincipal: (suspend AuthenticationContext.(UserRecord) -> Principal?)? = null

        fun mapPrincipal(body: suspend AuthenticationContext.(UserRecord) -> Principal?) {
            mapPrincipal = body
        }

        fun build(): FirebaseAuthProvider {
            requireNotNull(firebase)
            requireNotNull(mapPrincipal)
            return FirebaseAuthProvider(this)
        }
    }
}

class FirebasePrincipal(val userRecord: UserRecord) : Principal
class UserPrincipal(val user: User) : Principal

fun AuthenticationConfig.firebase(
    name: String? = null,
    configure: FirebaseAuthProvider.Config.() -> Unit
) {
    val provider = FirebaseAuthProvider.Config(name).apply(configure).build()
    register(provider)
}