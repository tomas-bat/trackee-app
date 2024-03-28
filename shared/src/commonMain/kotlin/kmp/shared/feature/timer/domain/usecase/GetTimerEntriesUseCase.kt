package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.timer.domain.model.TimerEntryPreview
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Get timer entries for the signed user
 *
 * **Returns** List<TimerEntryPreview>
 */
interface GetTimerEntriesUseCase : UseCaseResultNoParams<List<TimerEntryPreview>>

internal class GetTimerEntriesUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerEntriesUseCase {
    override suspend fun invoke(): Result<List<TimerEntryPreview>> =
        timerRepository.readEntryPreviews()
}