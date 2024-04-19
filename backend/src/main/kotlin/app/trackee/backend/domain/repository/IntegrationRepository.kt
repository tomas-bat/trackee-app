package app.trackee.backend.domain.repository

import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration

interface IntegrationRepository {

    suspend fun createIntegration(uid: String, integration: NewIntegration)

    suspend fun readIntegration(uid: String, integrationId: String): Integration

    suspend fun readIntegrations(uid: String): List<Integration>

    suspend fun updateIntegration(uid: String, integration: Integration)

    suspend fun deleteIntegration(uid: String, integrationId: String)
}