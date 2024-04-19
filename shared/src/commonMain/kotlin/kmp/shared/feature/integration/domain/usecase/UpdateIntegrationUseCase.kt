package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.integration.domain.model.Integration
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

/**
 * Updates an integration.
 *
 * **Input**: UpdateIntegrationUseCase.Params
 *
 * **Returns**: Unit
 */
interface UpdateIntegrationUseCase : UseCaseResult<UpdateIntegrationUseCase.Params, Unit> {
    /**
     * @param integration The integration to be updated.
     */
    data class Params(
        val integration: Integration
    )
}

internal class UpdateIntegrationUseCaseImpl(
    private val repository: IntegrationRepository
) : UpdateIntegrationUseCase {
    override suspend fun invoke(params: UpdateIntegrationUseCase.Params): Result<Unit> =
        repository.updateIntegration(params.integration)
}