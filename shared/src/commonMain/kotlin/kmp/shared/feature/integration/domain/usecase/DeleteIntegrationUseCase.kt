package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

/**
 * Deletes an integration.
 *
 * **Input**: DeleteIntegrationUseCase.Params
 *
 * **Returns**: Unit
 */
interface DeleteIntegrationUseCase : UseCaseResult<DeleteIntegrationUseCase.Params, Unit> {
    /**
     * @param integrationId Integration ID
     */
    data class Params(
        val integrationId: String
    )
}

internal class DeleteIntegrationUseCaseImpl(
    private val repository: IntegrationRepository
) : DeleteIntegrationUseCase {
    override suspend fun invoke(params: DeleteIntegrationUseCase.Params): Result<Unit> =
        repository.deleteIntegration(params.integrationId)
}