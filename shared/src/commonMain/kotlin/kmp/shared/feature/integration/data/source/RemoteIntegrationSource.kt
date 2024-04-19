package kmp.shared.feature.integration.data.source

import kmp.shared.base.Result
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.model.NewIntegration

internal interface RemoteIntegrationSource {

    suspend fun createIntegration(integration: NewIntegration): Result<Unit>

    suspend fun readIntegration(integrationId: String): Result<Integration>

    suspend fun readIntegrations(): Result<List<Integration>>

    suspend fun updateIntegration(integration: Integration): Result<Unit>

    suspend fun deleteIntegration(integrationId: String): Result<Unit>
}