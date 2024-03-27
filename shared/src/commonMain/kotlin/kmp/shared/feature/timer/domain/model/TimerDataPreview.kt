package kmp.shared.feature.timer.domain.model

import kotlinx.datetime.Instant

data class TimerDataPreview(
    val status: TimerStatus,
    val type: TimerType,
    val client: Client?,
    val project: Project?,
    val description: String?,
    val startedAt: Instant?,
)