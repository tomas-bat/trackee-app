package kmp.shared.feature.intent.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.intent.domain.repository.IntentRepository

/**
 * Cancels the current timer. If no timer is running, it does nothing.
 *
 * **Returns:** Unit
 */
interface CancelTimerUseCase : UseCaseResultNoParams<Unit>

internal class CancelTimerUseCaseImpl(
    private val repository: IntentRepository
) : CancelTimerUseCase {
    override suspend fun invoke(): Result<Unit> =
        repository.cancelTimer()
}