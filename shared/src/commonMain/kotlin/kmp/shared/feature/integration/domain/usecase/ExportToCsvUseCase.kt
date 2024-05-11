package kmp.shared.feature.integration.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.integration.domain.repository.IntegrationRepository
import kotlinx.datetime.Instant

/**
 * Exports all user entries in the given range (from-to) into a CSV file, which is returned as String.
 *
 * **Input**: ExportToCsvUseCase.Params
 *
 * **Returns**: String
 */
interface ExportToCsvUseCase : UseCaseResult<ExportToCsvUseCase.Params, String> {
    /**
     * @param integrationId Identifier of the integration.
     * @param from Date from which the entries should be exported.
     * @param to Date until which the entries should be exported.
     */
    data class Params(
        val integrationId: String,
        val from: Instant?,
        val to: Instant
    )
}

internal class ExportToCsvUseCaseImpl(
    private val repository: IntegrationRepository
) : ExportToCsvUseCase {
    override suspend fun invoke(params: ExportToCsvUseCase.Params): Result<String> =
        repository.exportToCsv(params.integrationId, params.from, params.to)
}