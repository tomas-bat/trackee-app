package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerDataPreview
import kmp.shared.feature.timer.domain.model.TimerStatus
import kmp.shared.feature.timer.domain.model.TimerType
import kotlinx.datetime.toInstant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TimerDataPreviewDto(
    val status: String,
    val client: ClientDto?,
    val project: ProjectDto?,
    val description: String?,
    @SerialName("started_at") val startedAt: String?,
    @SerialName("available_projects") val availableProjects: List<ProjectDto>
)

fun TimerDataPreviewDto.toDomain(type: TimerType): TimerDataPreview =
    TimerDataPreview(
        status = TimerStatus.entries.firstOrNull { it.rawValue == status } ?: TimerStatus.Off,
        type = type,
        client = client?.toDomain(),
        project = project?.toDomain(),
        description = description,
        startedAt = startedAt?.toInstant(),
        availableProjects = availableProjects.map { it.toDomain() }
    )