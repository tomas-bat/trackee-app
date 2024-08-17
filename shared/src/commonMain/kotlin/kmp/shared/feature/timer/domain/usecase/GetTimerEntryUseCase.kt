package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.timer.domain.model.TimerEntryPreview
import kmp.shared.feature.timer.domain.repository.TimerRepository

interface GetTimerEntryUseCase : UseCaseResult<GetTimerEntryUseCase.Params, TimerEntryPreview> {

    /**
     * @param entryId Entry ID
     */
    data class Params(
        val entryId: String
    )
}

internal class GetTimerEntryUseCaseImpl(
    private val repository: TimerRepository
) : GetTimerEntryUseCase {
    override suspend fun invoke(params: GetTimerEntryUseCase.Params): Result<TimerEntryPreview> =
        repository.readEntry(params.entryId)
}