package app.trackee.backend.presentation.model.integration

import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.presentation.model.project.IdentifiableProjectDto
import app.trackee.backend.presentation.model.project.toDomain
import app.trackee.backend.presentation.model.project.toDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal sealed class IntegrationDto  {
    abstract val id: String
    abstract val label: String
    abstract val selectedProjects: List<IdentifiableProjectDto>

    @Serializable
    @SerialName("csv")
    data class Csv(
        override val id: String,
        override val label: String,
        @SerialName("selected_projects") override val selectedProjects: List<IdentifiableProjectDto>
    ) : IntegrationDto()

    @Serializable
    @SerialName("clockify")
    data class Clockify(
        override val id: String,
        override val label: String,
        @SerialName("api_key") val apiKey: String?,
        @SerialName("workspace_name") val workspaceName: String?,
        @SerialName("auto_export") val autoExport: Boolean,
        @SerialName("selected_projects") override val selectedProjects: List<IdentifiableProjectDto>
    ) : IntegrationDto()
}

internal fun Integration.Csv.toDto() = IntegrationDto.Csv(
    id = id,
    label = label,
    selectedProjects = selectedProjects.map { it.toDto() }
)

internal fun IntegrationDto.Csv.toDomain() = Integration.Csv(
    id = id,
    label = label,
    selectedProjects = selectedProjects.map { it.toDomain() }
)

internal fun Integration.Clockify.toDto() = IntegrationDto.Clockify(
    id = id,
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport,
    selectedProjects = selectedProjects.map { it.toDto() }
)

internal fun IntegrationDto.Clockify.toDomain() = Integration.Clockify(
    id = id,
    label = label,
    apiKey = apiKey,
    workspaceName = workspaceName,
    autoExport = autoExport,
    selectedProjects = selectedProjects.map { it.toDomain() }
)

internal fun Integration.toDto() = when (this) {
    is Integration.Csv -> this.toDto()
    is Integration.Clockify -> this.toDto()
}

internal fun IntegrationDto.toDomain() = when(this) {
    is IntegrationDto.Csv -> this.toDomain()
    is IntegrationDto.Clockify -> this.toDomain()
}
