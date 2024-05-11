package kmp.shared.feature.integration.infrastructure.model

import kmp.shared.feature.integration.domain.model.NewIntegration
import kmp.shared.feature.timer.infrastructure.model.IdentifiableProjectDto
import kmp.shared.feature.timer.infrastructure.model.toDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal sealed class NewIntegrationDto  {
    abstract val label: String
    abstract val selectedProjects: List<IdentifiableProjectDto>

    @Serializable
    @SerialName("csv")
    data class Csv(
        override val label: String,
        @SerialName("selected_projects") override val selectedProjects: List<IdentifiableProjectDto>
    ) : NewIntegrationDto()

    @Serializable
    @SerialName("clockify")
    data class Clockify(
        override val label: String,
        @SerialName("selected_projects") override val selectedProjects: List<IdentifiableProjectDto>,
        @SerialName("api_key") val apiKey: String?,
        @SerialName("workspace_name") val workspaceName: String?,
        @SerialName("auto_export") val autoExport: Boolean
    ) : NewIntegrationDto()
}

internal fun NewIntegration.Csv.toDto() = NewIntegrationDto.Csv(
    label = label,
    selectedProjects = selectedProjects.map { it.toDto() }
)

internal fun NewIntegration.Clockify.toDto() = NewIntegrationDto.Clockify(
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport,
    selectedProjects = selectedProjects.map { it.toDto() }
)

internal fun NewIntegration.toDto() = when(this) {
    is NewIntegration.Csv -> this.toDto()
    is NewIntegration.Clockify -> this.toDto()
}
