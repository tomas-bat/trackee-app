package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.integration.domain.model.NewClockifyExportRequest
import kmp.shared.feature.integration.domain.repository.IntegrationRepository

/**
 * Exports all user entries in the given range (from-to) to a Clockify account identified by its API key.
 *
 * **Input**: ExportToClockifyUseCase.Params
 *
 * **Returns**: Unit
 */
interface ExportToClockifyUseCase : UseCaseResult<ExportToClockifyUseCase.Params, Unit> {
    /**
     * @param integrationId Identifier of the integration.
     * @param request The export request parameters.
     */
    data class Params(
        val integrationId: String,
        val request: NewClockifyExportRequest
    )
}

internal class ExportToClockifyUseCaseImpl(
    private val repository: IntegrationRepository
) : ExportToClockifyUseCase {
    override suspend fun invoke(params: ExportToClockifyUseCase.Params): Result<Unit> =
        repository.exportToClockify(params.integrationId, params.request)
}