package kmp.shared.feature.intent.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.intent.domain.model.StartTimerBody
import kmp.shared.feature.intent.domain.repository.IntentRepository

/**
 * Starts the timer of the current user. If the timer is already running, it does nothing.
 *
 * **Input**: StartTimerUseCase.Params
 *
 * **Returns:** Unit
 */
interface StartTimerUseCase : UseCaseResult<StartTimerUseCase.Params, Unit> {
    /**
     * @param body Body for the timer start request
     */
    data class Params(
        val body: StartTimerBody
    )
}

internal class StartTimerUseCaseImpl(
    private val repository: IntentRepository
) : StartTimerUseCase {
    override suspend fun invoke(params: StartTimerUseCase.Params): Result<Unit> =
        repository.startTimer(params.body)
}