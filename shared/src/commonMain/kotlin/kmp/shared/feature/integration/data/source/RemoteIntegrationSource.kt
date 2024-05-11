package kmp.shared.feature.integration.data.source

import kmp.shared.base.Result
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.model.NewClockifyExportRequest
import kmp.shared.feature.integration.domain.model.NewIntegration

internal interface RemoteIntegrationSource {

    suspend fun createIntegration(integration: NewIntegration): Result<Unit>

    suspend fun readIntegration(integrationId: String): Result<Integration>

    suspend fun readIntegrations(): Result<List<Integration>>

    suspend fun updateIntegration(integration: Integration): Result<Unit>

    suspend fun deleteIntegration(integrationId: String): Result<Unit>

    suspend fun exportToCsv(integrationId: String, from: String?, to: String?): Result<String>

    suspend fun exportToClockify(integrationId: String, request: NewClockifyExportRequest): Result<Unit>
}