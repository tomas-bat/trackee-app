package kmp.shared.feature.integration.data.repository

import kmp.shared.base.Result
import kmp.shared.feature.integration.data.source.RemoteIntegrationSource
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.model.NewIntegration
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

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
}