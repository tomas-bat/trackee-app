package app.trackee.backend.domain.model.integration

import app.trackee.backend.domain.model.project.IdentifiableProject

sealed class NewIntegration {
    abstract val label: String
    abstract val selectedProjects: List<IdentifiableProject>

    data class Csv(
        override val label: String,
        override val selectedProjects: List<IdentifiableProject>
    ) : NewIntegration()

    data class Clockify(
        override val label: String,
        override val selectedProjects: List<IdentifiableProject>,
        val apiKey: String?,
        val workspaceName: String?,
        val autoExport: Boolean
    ) : NewIntegration()
}
