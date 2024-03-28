package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.timer.domain.model.TimerData
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Update timer data
 *
 * **Input:** UpdateTimerDataUseCase.Params
 *
 * **Returns:** Unit
 */
interface UpdateTimerDataUseCase : UseCaseResult<UpdateTimerDataUseCase.Params, Unit> {
    /**
     * @param timerData Timer data
     */
    data class Params(
        val timerData: TimerData
    )
}

internal class UpdateTimerDataUseCaseImpl(
    private val timerRepository: TimerRepository
) : UpdateTimerDataUseCase {
    override suspend fun invoke(params: UpdateTimerDataUseCase.Params): Result<Unit> =
        timerRepository.updateTimerData(params.timerData)
}