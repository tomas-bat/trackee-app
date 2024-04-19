package app.trackee.backend.data.source

import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration

internal interface IntegrationSource {

    suspend fun createIntegration(uid: String, integration: NewIntegration)

    suspend fun readIntegration(uid: String, integrationId: String): Integration

    suspend fun readIntegrations(uid: String): List<Integration>

    suspend fun updateIntegration(uid: String, integration: Integration)

    suspend fun deleteIntegration(uid: String, integrationId: String)
}