package app.trackee.backend.domain.model.timer

data class StartTimerBody(
    val clientId: String?,
    val projectId: String?,
    val description: String?
)