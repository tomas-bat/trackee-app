package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Delete entry by id for signed user
 *
 * **Input:** DeleteTimerEntryUseCase.Params
 *
 * **Returns:** Unit
 */
interface DeleteTimerEntryUseCase : UseCaseResult<DeleteTimerEntryUseCase.Params, Unit> {
    /**
     * @param entryId Entry ID
     */
    data class Params(
        val entryId: String
    )
}

internal class DeleteTimerEntryUseCaseImpl(
    private val timerRepository: TimerRepository
) : DeleteTimerEntryUseCase {
    override suspend fun invoke(params: DeleteTimerEntryUseCase.Params): Result<Unit> =
        timerRepository.deleteEntry(params.entryId)
}