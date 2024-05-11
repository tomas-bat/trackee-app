package kmp.shared.feature.integration.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.model.NewClockifyExportRequest
import kmp.shared.feature.integration.domain.model.NewIntegration
import kotlinx.datetime.Instant

internal interface IntegrationRepository {
    suspend fun createIntegration(integration: NewIntegration): Result<Unit>

    suspend fun readIntegration(integrationId: String): Result<Integration>

    suspend fun readIntegrations(): Result<List<Integration>>

    suspend fun updateIntegration(integration: Integration): Result<Unit>

    suspend fun deleteIntegration(integrationId: String): Result<Unit>

    suspend fun exportToCsv(
        integrationId: String,
        from: Instant?,
        to: Instant?
    ): Result<String>

    suspend fun exportToClockify(
        integrationId: String,
        request: NewClockifyExportRequest
    ): Result<Unit>
}