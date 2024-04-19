package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

/**
 * Gets an integration by ID.
 *
 * **Input**: GetIntegrationUseCase.Params
 *
 * **Returns: Integration
 */
interface GetIntegrationUseCase : UseCaseResult<GetIntegrationUseCase.Params, Integration> {
    /**
     * @param integrationId Integration ID
     */
    data class Params(
        val integrationId: String
    )
}

internal class GetIntegrationUseCaseImpl(
    private val repository: IntegrationRepository
) : GetIntegrationUseCase {
    override suspend fun invoke(params: GetIntegrationUseCase.Params): Result<Integration> =
        repository.readIntegration(params.integrationId)
}