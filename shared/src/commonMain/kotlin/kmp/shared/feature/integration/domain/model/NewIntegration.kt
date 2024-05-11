package kmp.shared.feature.integration.domain.model

import kmp.shared.feature.timer.domain.model.IdentifiableProject

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