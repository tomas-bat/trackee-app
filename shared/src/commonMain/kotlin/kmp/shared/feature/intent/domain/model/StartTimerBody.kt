package kmp.shared.feature.intent.domain.model

data class StartTimerBody(
    val clientId: String?,
    val projectId: String?,
    val description: String?
)