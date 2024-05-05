package app.trackee.backend.presentation.model.integration

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClockifyExportRequestDto(
    @SerialName("api_key") val apiKey: String,
    @SerialName("workspace_name") val workspaceName: String?,
    val from: String,
    val to: String
)