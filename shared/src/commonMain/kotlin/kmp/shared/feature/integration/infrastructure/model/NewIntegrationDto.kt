package kmp.shared.feature.integration.infrastructure.model

import kmp.shared.feature.integration.domain.model.NewIntegration
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

internal fun NewIntegration.Csv.toDto() = NewIntegrationDto.Csv(
    label = label
)

internal fun NewIntegration.Clockify.toDto() = NewIntegrationDto.Clockify(
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport
)

internal fun NewIntegration.toDto() = when(this) {
    is NewIntegration.Csv -> this.toDto()
    is NewIntegration.Clockify -> this.toDto()
}
