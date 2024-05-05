package app.trackee.backend.presentation.model.integration

import app.trackee.backend.presentation.model.entry.TimerEntryPreviewDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClockifyEntryRequestDto(
    @SerialName("api_key") val apiKey: String,
    @SerialName("workspace_id") val workspaceId: String,
    val entry: TimerEntryPreviewDto
)
