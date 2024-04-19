package app.trackee.backend.data.repository

import app.trackee.backend.data.source.IntegrationSource
import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration
import app.trackee.backend.domain.repository.IntegrationRepository

internal class IntegrationRepositoryImpl(
    private val source: IntegrationSource
) : IntegrationRepository {

    override suspend fun createIntegration(uid: String, integration: NewIntegration) =
        source.createIntegration(uid, integration)

    override suspend fun readIntegration(uid: String, integrationId: String): Integration =
        source.readIntegration(uid, integrationId)

    override suspend fun readIntegrations(uid: String): List<Integration> =
        source.readIntegrations(uid)

    override suspend fun updateIntegration(uid: String, integration: Integration) =
        source.updateIntegration(uid, integration)

    override suspend fun deleteIntegration(uid: String, integrationId: String) =
        source.deleteIntegration(uid, integrationId)
}