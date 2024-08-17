package app.trackee.backend.presentation.route.user

import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.domain.repository.IntegrationRepository
import app.trackee.backend.domain.repository.UserRepository
import app.trackee.backend.presentation.model.client.toDto
import app.trackee.backend.presentation.model.entry.NewTimerEntryDto
import app.trackee.backend.presentation.model.entry.TimerEntryDto
import app.trackee.backend.presentation.model.entry.toDomain
import app.trackee.backend.presentation.model.entry.toDto
import app.trackee.backend.presentation.model.project.toDto
import app.trackee.backend.presentation.model.timer.StartTimerBodyDto
import app.trackee.backend.presentation.model.timer.TimerDataDto
import app.trackee.backend.presentation.model.timer.toDomain
import app.trackee.backend.presentation.model.timer.toDto
import app.trackee.backend.presentation.model.user.toDto
import app.trackee.backend.presentation.util.requireUserPrincipal
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*
import kotlinx.datetime.toInstant
import org.koin.ktor.ext.inject

fun Routing.userRoute() {
    val userRepository by inject<UserRepository>()
    val integration by inject<IntegrationRepository>()

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
                    val startAfter = call.request.queryParameters["startAfter"]
                    val limit = call.request.queryParameters["limit"]
                    val endAt = call.request.queryParameters["endAt"]

                    val entryDtos = userRepository.readEntries(
                        uid = uid,
                        startAfter = startAfter?.toInstant(),
                        limit = limit?.toInt(),
                        endAt = endAt?.toInstant()
                    ).toDto()

                    call.respond(HttpStatusCode.OK, entryDtos)
                }
            }
        }

        route("/user") {
            get {
                val userDto = call.requireUserPrincipal().user.toDto()
                call.respond(HttpStatusCode.OK, userDto)
            }

            delete {
                val user = call.requireUserPrincipal().user
                userRepository.deleteUser(user.uid)

                call.respond(HttpStatusCode.OK)
            }

            route("/entries") {
                get {
                    val user = call.requireUserPrincipal().user
                    val startAfter = call.request.queryParameters["startAfter"]
                    val limit = call.request.queryParameters["limit"]
                    val endAt = call.request.queryParameters["endAt"]

                    val entryDtos = userRepository.readEntries(
                        uid = user.uid,
                        startAfter = startAfter?.toInstant(),
                        limit = limit?.toInt(),
                        endAt = endAt?.toInstant()
                    ).toDto()

                    call.respond(HttpStatusCode.OK, entryDtos)
                }

                post<NewTimerEntryDto> { body ->
                    val user = call.requireUserPrincipal().user

                    val entry = userRepository.createEntry(
                        uid = user.uid,
                        entry = body.toDomain()
                    )

                    val entryPreview = userRepository.readEntryPreview(user.uid, entry.id)
                    integration.createEntryForAutoExports(user.uid, entryPreview)

                    call.respond(HttpStatusCode.Created)
                }

                get("/previews") {
                    val user = call.requireUserPrincipal().user
                    val startAfter = call.request.queryParameters["startAfter"]
                    val limit = call.request.queryParameters["limit"]
                    val endAt = call.request.queryParameters["endAt"]


                    val entryPreviewDtos = userRepository.readEntryPreviews(
                        uid = user.uid,
                        startAfter = startAfter?.toInstant(),
                        limit = limit?.toInt(),
                        endAt = endAt?.toInstant()
                    ).toDto()

                    call.respond(HttpStatusCode.OK, entryPreviewDtos)
                }

                route("/{entryId}") {
                    get("/preview") {
                        val user = call.requireUserPrincipal().user
                        val entryId: String by call.parameters

                        val entry = userRepository.readEntryPreview(user.uid, entryId)

                        call.respond(HttpStatusCode.OK, entry.toDto())
                    }

                    put<TimerEntryDto> { body ->
                        val user = call.requireUserPrincipal().user
                        val entryId: String by call.parameters

                        if (entryId != body.id) throw UserException.EntryIdMismatch(user.uid, entryId, body.id)

                        val entry = userRepository.updateEntry(user.uid, body.toDomain())

                        if (entry.clockifyEntryId != null && entry.clockifyWorkspaceId != null) {
                            val entryPreview = userRepository.readEntryPreview(user.uid, entryId)
                            val apiKey = integration.inferClockifyApiKey(user.uid, entry)
                            integration.updateClockifyEntry(apiKey, entryPreview)
                        }

                        call.respond(HttpStatusCode.OK)
                    }

                    delete {
                        val user = call.requireUserPrincipal().user
                        val entryId: String by call.parameters

                        val entry = userRepository.readEntryById(user.uid, entryId)
                        userRepository.deleteEntry(user.uid, entryId)

                        if (entry.clockifyEntryId != null && entry.clockifyWorkspaceId != null) {
                            val apiKey = integration.inferClockifyApiKey(user.uid, entry)
                            integration.removeClockifyEntry(apiKey, entry.clockifyWorkspaceId, entry.clockifyEntryId)
                        }

                        call.respond(HttpStatusCode.OK)
                    }
                }
            }

            route("/timer") {
                get {
                    val user = call.requireUserPrincipal().user
                    val timerDataDto = userRepository.readTimer(user.uid).toDto()

                    call.respond(HttpStatusCode.OK, timerDataDto)
                }

                put<TimerDataDto> { body ->
                    val user = call.requireUserPrincipal().user
                    userRepository.updateTimer(user.uid, body.toDomain())

                    call.respond(HttpStatusCode.Accepted)
                }

                get("/preview") {
                    val user = call.requireUserPrincipal().user
                    val timerDataPreviewDto = userRepository.readTimerPreview(user.uid).toDto()

                    call.respond(HttpStatusCode.OK, timerDataPreviewDto)
                }

                put<StartTimerBodyDto>("/start") { body ->
                    val user = call.requireUserPrincipal().user
                    userRepository.startTimer(user.uid, body.toDomain())

                    call.respond(HttpStatusCode.OK)
                }

                put("/cancel") {
                    val user = call.requireUserPrincipal().user
                    userRepository.stopTimer(user.uid)

                    call.respond(HttpStatusCode.OK)
                }

                post("/save_and_stop") {
                    val user = call.requireUserPrincipal().user
                    val entry = userRepository.createEntryFromTimer(user.uid)
                    userRepository.stopTimer(user.uid)

                    if (entry != null) {
                        val entryPreview = userRepository.readEntryPreview(user.uid, entry.id)
                        integration.createEntryForAutoExports(user.uid, entryPreview)
                    }

                    call.respond(HttpStatusCode.OK)
                }
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

                put("/add") {
                    val user = call.requireUserPrincipal().user
                    val clientId: String by call.request.queryParameters
                    val projectId: String by call.request.queryParameters

                    userRepository.assignProjectToUser(user.uid, clientId, projectId)

                    call.respond(HttpStatusCode.OK)
                }
            }

            route("/clients") {
                get {
                    val user = call.requireUserPrincipal().user
                    val clientDtos = userRepository.readClients(user.uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, clientDtos)
                }

                put("/add") {
                    val user = call.requireUserPrincipal().user
                    val clientId: String by call.request.queryParameters

                    userRepository.assignClientToUser(user.uid, clientId)

                    call.respond(HttpStatusCode.OK)
                }
            }

            route("/summaries") {
                get {
                    val user = call.requireUserPrincipal().user
                    val summaryDtos = userRepository.readTimerSummariesUseCase(user.uid).map { it.toDto() }

                    call.respond(HttpStatusCode.OK, summaryDtos)
                }
            }
        }
    }
}