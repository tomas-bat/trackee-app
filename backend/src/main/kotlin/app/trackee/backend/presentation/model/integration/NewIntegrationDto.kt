package app.trackee.backend.presentation.model.integration

import app.trackee.backend.domain.model.integration.NewIntegration
import app.trackee.backend.presentation.model.project.IdentifiableProjectDto
import app.trackee.backend.presentation.model.project.toDomain
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

internal fun NewIntegrationDto.Csv.toDomain() = NewIntegration.Csv(
    label = label,
    selectedProjects = selectedProjects.map { it.toDomain() }
)

internal fun NewIntegrationDto.Clockify.toDomain() = NewIntegration.Clockify(
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport,
    selectedProjects = selectedProjects.map { it.toDomain() }
)

internal fun NewIntegrationDto.toDomain() = when(this) {
    is NewIntegrationDto.Csv -> this.toDomain()
    is NewIntegrationDto.Clockify -> this.toDomain()
}