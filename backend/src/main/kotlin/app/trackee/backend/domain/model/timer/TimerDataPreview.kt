package app.trackee.backend.domain.model.timer

import app.trackee.backend.domain.model.client.Client
import app.trackee.backend.domain.model.project.Project
import kotlinx.datetime.Instant

data class TimerDataPreview(
    val status: TimerStatus,
    val client: Client?,
    val project: Project?,
    val description: String?,
    val startedAt: Instant?,
    val availableProjects: List<Project>
)