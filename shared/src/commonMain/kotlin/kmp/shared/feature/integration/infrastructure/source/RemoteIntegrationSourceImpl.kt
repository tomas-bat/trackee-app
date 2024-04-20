package kmp.shared.feature.integration.infrastructure.source

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.feature.integration.data.source.RemoteIntegrationSource
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.model.NewIntegration
import kmp.shared.feature.integration.infrastructure.model.IntegrationDto
import kmp.shared.feature.integration.infrastructure.model.toDomain
import kmp.shared.feature.integration.infrastructure.model.toDto

internal class RemoteIntegrationSourceImpl(
    private val client: HttpClient
) : RemoteIntegrationSource {
    override suspend fun createIntegration(integration: NewIntegration): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.post("integrations/add") {
                setBody(integration.toDto())
            }
        }

    override suspend fun readIntegration(integrationId: String): Result<Integration> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("integrations/${integrationId}")
            res.body<IntegrationDto>().toDomain()
        }

    override suspend fun readIntegrations(): Result<List<Integration>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("integrations")
            res.body<List<IntegrationDto>>().map { it.toDomain() }
        }

    override suspend fun updateIntegration(integration: Integration): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("integrations/${integration.id}") {
                setBody(integration.toDto())
            }
        }

    override suspend fun deleteIntegration(integrationId: String): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.delete("integrations/${integrationId}")
        }

    override suspend fun exportToCsv(from: String?, to: String?): Result<String> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("integrations/csv") {
                url {
                    from?.let { parameters.append("from", it) }
                    to?.let { parameters.append("to", it) }
                }
            }
            res.bodyAsText()
        }
}