package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Starts the timer of the current user. If the timer is already running, it does nothing.
 *
 * **Returns:** Unit
 */
interface StartTimerUseCase : UseCaseResultNoParams<Unit>

internal class StartTimerUseCaseImpl(
    private val repository: TimerRepository
) : StartTimerUseCase {
    override suspend fun invoke(): Result<Unit> =
        repository.startTimer()
}