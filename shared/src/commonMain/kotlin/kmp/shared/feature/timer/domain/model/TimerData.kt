package kmp.shared.feature.timer.domain.model

import kotlinx.datetime.Instant

data class TimerData (
    val status: TimerStatus,
    val clientId: String?,
    val projectId: String?,
    val description: String?,
    val startedAt: Instant?,
)