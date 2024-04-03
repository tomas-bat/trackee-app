package kmp.shared.feature.profile.domain.model

import kmp.shared.feature.timer.domain.model.ProjectType

data class NewProject(
    val clientId: String,
    val type: ProjectType?,
    val name: String
)