package kmp.shared.feature.integration.infrastructure.model

import kmp.shared.feature.integration.domain.model.Integration
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed class IntegrationDto  {
    abstract val id: String
    abstract val label: String

    @Serializable
    @SerialName("csv")
    data class Csv(
        override val id: String,
        override val label: String
    ) : IntegrationDto()

    @Serializable
    @SerialName("clockify")
    data class Clockify(
        override val id: String,
        override val label: String,
        @SerialName("api_key") val apiKey: String?,
        @SerialName("workspace_name") val workspaceName: String?,
        @SerialName("auto_export") val autoExport: Boolean
    ) : IntegrationDto()
}

internal fun Integration.Csv.toDto() = IntegrationDto.Csv(
    id = id,
    label = label
)

internal fun IntegrationDto.Csv.toDomain() = Integration.Csv(
    id = id,
    label = label
)

internal fun Integration.Clockify.toDto() = IntegrationDto.Clockify(
    id = id,
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport
)

internal fun IntegrationDto.Clockify.toDomain() = Integration.Clockify(
    id = id,
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport
)

internal fun Integration.toDto() = when (this) {
    is Integration.Csv -> this.toDto()
    is Integration.Clockify -> this.toDto()
}

internal fun IntegrationDto.toDomain() = when(this) {
    is IntegrationDto.Csv -> this.toDomain()
    is IntegrationDto.Clockify -> this.toDomain()
}