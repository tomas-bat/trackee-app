package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.timer.domain.model.TimerSummary
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Get timer summaries for the signed user
 *
 * **Returns:** List<TimerSummary>
 */
interface GetTimerSummariesUseCase : UseCaseResultNoParams<List<TimerSummary>>

internal class GetTimerSummariesUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerSummariesUseCase {
    override suspend fun invoke(): Result<List<TimerSummary>> =
        timerRepository.readTimerSummaries()
}