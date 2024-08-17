package kmp.shared.feature.timer.domain.model

import kotlinx.datetime.Instant

data class TimerEntryPreview(
    val id: String,
    val project: Project,
    val client: Client,
    val description: String?,
    val startedAt: Instant,
    val endedAt: Instant,
    val clockifyEntryId: String?,
    val clockifyWorkspaceId: String?
)