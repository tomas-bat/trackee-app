package app.trackee.backend.presentation.model.entry

import app.trackee.backend.domain.model.entry.NewTimerEntry
import kotlinx.datetime.toInstant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class NewTimerEntryDto(
    @SerialName("client_id") val clientId: String,
    @SerialName("project_id") val projectId: String,
    val description: String?,
    @SerialName("started_at") val startedAt: String,
    @SerialName("ended_at") val endedAt: String
)

internal fun NewTimerEntryDto.toDomain() = NewTimerEntry(
    clientId = clientId,
    projectId = projectId,
    description = description,
    startedAt = startedAt.toInstant(),
    endedAt = endedAt.toInstant()
)