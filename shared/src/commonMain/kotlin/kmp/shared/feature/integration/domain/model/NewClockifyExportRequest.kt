package kmp.shared.feature.integration.domain.model

import kotlinx.datetime.Instant

data class NewClockifyExportRequest(
    val apiKey: String,
    val workspaceName: String?,
    val from: Instant,
    val to: Instant
)