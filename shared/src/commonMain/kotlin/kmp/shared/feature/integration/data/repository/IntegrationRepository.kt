package kmp.shared.feature.integration.data.repository

import kmp.shared.base.Result
import kmp.shared.feature.integration.data.source.RemoteIntegrationSource
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.model.NewClockifyExportRequest
import kmp.shared.feature.integration.domain.model.NewIntegration
import kmp.shared.feature.integration.domain.repository.IntegrationRepository
import kotlinx.datetime.Instant

internal class IntegrationRepositoryImpl(
    private val source: RemoteIntegrationSource
) : IntegrationRepository {
    override suspend fun createIntegration(integration: NewIntegration): Result<Unit> =
        source.createIntegration(integration)

    override suspend fun readIntegration(integrationId: String): Result<Integration> =
        source.readIntegration(integrationId)

    override suspend fun readIntegrations(): Result<List<Integration>> =
        source.readIntegrations()

    override suspend fun updateIntegration(integration: Integration): Result<Unit> =
        source.updateIntegration(integration)

    override suspend fun deleteIntegration(integrationId: String): Result<Unit> =
        source.deleteIntegration(integrationId)

    override suspend fun exportToCsv(
        integrationId: String,
        from: Instant?, to: Instant?
    ): Result<String> =
        source.exportToCsv(integrationId, from.toString(), to.toString())

    override suspend fun exportToClockify(
        integrationId: String,
        request: NewClockifyExportRequest
    ): Result<Unit> =
        source.exportToClockify(integrationId, request)
}