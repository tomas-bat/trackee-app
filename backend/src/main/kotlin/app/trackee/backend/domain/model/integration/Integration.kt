package app.trackee.backend.domain.model.integration

import app.trackee.backend.domain.model.project.IdentifiableProject

sealed class Integration {
    abstract val id: String
    abstract val label: String
    abstract val selectedProjects: List<IdentifiableProject>

    data class Csv(
        override val id: String,
        override val label: String,
        override val selectedProjects: List<IdentifiableProject>,
    ) : Integration()

    data class Clockify(
        override val id: String,
        override val label: String,
        override val selectedProjects: List<IdentifiableProject>,
        val apiKey: String?,
        val workspaceName: String?,
        val autoExport: Boolean
    ) : Integration()
}