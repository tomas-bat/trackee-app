package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.timer.domain.model.TimerDataPreview
import kmp.shared.feature.timer.domain.repository.TimerRepository

interface GetTimerDataPreviewUseCase : UseCaseResultNoParams<TimerDataPreview>

internal class GetTimerDataPreviewUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerDataPreviewUseCase {
    override suspend fun invoke(): Result<TimerDataPreview> =
        timerRepository.readTimerDataPreview()
}