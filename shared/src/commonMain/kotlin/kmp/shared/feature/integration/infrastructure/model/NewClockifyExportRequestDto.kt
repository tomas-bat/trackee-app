package kmp.shared.feature.integration.infrastructure.model

import kmp.shared.feature.integration.domain.model.NewClockifyExportRequest
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClockifyExportRequestDto(
    @SerialName("api_key") val apiKey: String,
    @SerialName("workspace_name") val workspaceName: String?,
    val from: String,
    val to: String
)

internal fun NewClockifyExportRequest.toDto() = NewClockifyExportRequestDto(
    apiKey = apiKey,
    workspaceName = workspaceName,
    from = from.toString(),
    to = to.toString()
)