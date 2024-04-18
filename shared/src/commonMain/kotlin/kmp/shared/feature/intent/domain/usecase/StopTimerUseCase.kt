package kmp.shared.feature.intent.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.intent.domain.repository.IntentRepository

/**
 * Creates a new timer entry from current timer data and stops the timer.
 * If the timer is not running, it does nothing.
 * Fails if the current timer data is missing selected project.
 *
 * **Returns:** Unit
 */
interface StopTimerUseCase : UseCaseResultNoParams<Unit>

internal class StopTimerUseCaseImpl(
    private val repository: IntentRepository
) : StopTimerUseCase {
    override suspend fun invoke(): Result<Unit> =
        repository.stopTimer()
}