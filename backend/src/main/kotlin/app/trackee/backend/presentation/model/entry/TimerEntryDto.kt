package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.TimerEntry
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerEntryDto(
    val id: String,
    @SerialName("client_id") val clientId: String,
    @SerialName("project_id") val projectId: String,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String
)

internal fun TimerEntry.toDto() = TimerEntryDto(
    id = id,
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toString(),
    endedAt = endedAt.toString()
)