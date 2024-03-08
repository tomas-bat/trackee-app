package app.trackee.backend.presentation.util

import app.trackee.backend.config.exceptions.AuthException
import app.trackee.backend.config.firebase.UserPrincipal
import io.ktor.server.application.*
import io.ktor.server.auth.*

public fun ApplicationCall.requireUserPrincipal() =
    principal<UserPrincipal>() ?: throw AuthException.Unauthorized