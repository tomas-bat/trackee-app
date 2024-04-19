package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.integration.domain.model.NewIntegration
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

/**
 * Adds a new integration.
 *
 * **Input**: AddNewIntegrationUseCase.Params
 *
 * **Returns**: Unit
 */
interface AddIntegrationUseCase : UseCaseResult<AddIntegrationUseCase.Params, Unit> {
    /**
     * @param integration The new integration.
     */
    data class Params(
        val integration: NewIntegration
    )
}

internal class AddIntegrationUseCaseImpl(
    private val repository: IntegrationRepository
) : AddIntegrationUseCase {
    override suspend fun invoke(params: AddIntegrationUseCase.Params): Result<Unit> =
        repository.createIntegration(params.integration)
}