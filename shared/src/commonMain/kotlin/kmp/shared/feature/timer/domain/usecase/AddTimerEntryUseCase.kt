package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.timer.domain.model.NewTimerEntry
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Add a new timer entry for the signed user
 *
 * **Input:** AddTimerEntryUseCase.Params
 *
 * **Returns:** Unit
 */
interface AddTimerEntryUseCase : UseCaseResult<AddTimerEntryUseCase.Params, Unit> {
    /**
     * @param entry The new timer entry
     */
    data class Params(
        val entry: NewTimerEntry
    )
}

internal class AddTimerEntryUseCaseImpl(
    private val timerRepository: TimerRepository
) : AddTimerEntryUseCase {
    override suspend fun invoke(params: AddTimerEntryUseCase.Params): Result<Unit> =
        timerRepository.createEntry(params.entry)
}