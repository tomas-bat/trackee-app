package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.timer.domain.model.TimerEntry
import kmp.shared.feature.timer.domain.repository.TimerRepository

interface UpdateTimerEntryUseCase : UseCaseResult<UpdateTimerEntryUseCase.Params, TimerEntry> {
    /**
     * @param entry Updated entry
     */
    data class Params(
        val entry: TimerEntry
    )
}

internal class UpdateTimerEntryUseCaseImpl(
    private val repository: TimerRepository
) : UpdateTimerEntryUseCase {
    override suspend fun invoke(params: UpdateTimerEntryUseCase.Params): Result<TimerEntry> =
        repository.updateEntry(params.entry)
}

