package app.trackee.backend.presentation.model.integration

import app.trackee.backend.domain.model.integration.NewIntegration
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed class NewIntegrationDto  {
    abstract val label: String

    @Serializable
    @SerialName("csv")
    data class Csv(
        override val label: String
    ) : NewIntegrationDto()

    @Serializable
    @SerialName("clockify")
    data class Clockify(
        override val label: String,
        @SerialName("api_key") val apiKey: String?,
        @SerialName("workspace_name") val workspaceName: String?,
        @SerialName("auto_export") val autoExport: Boolean
    ) : NewIntegrationDto()
}

internal fun NewIntegrationDto.Csv.toDomain() = NewIntegration.Csv(
    label = label
)

internal fun NewIntegrationDto.Clockify.toDomain() = NewIntegration.Clockify(
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport
)

internal fun NewIntegrationDto.toDomain() = when(this) {
    is NewIntegrationDto.Csv -> this.toDomain()
    is NewIntegrationDto.Clockify -> this.toDomain()
}