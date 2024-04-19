package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

/**
 * Gets all integrations of the signed user.
 *
 * **Returns**: List<Integration>
 */
interface GetIntegrationsUseCase : UseCaseResultNoParams<List<Integration>>

internal class GetIntegrationsUseCaseImpl(
    private val repository: IntegrationRepository
) : GetIntegrationsUseCase {
    override suspend fun invoke(): Result<List<Integration>> =
        repository.readIntegrations()
}