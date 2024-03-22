package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.auth.domain.repository.AuthRepository
import kmp.shared.feature.timer.domain.model.TimerSummary
import kmp.shared.feature.timer.domain.model.TimerSummaryComponent
import kmp.shared.feature.timer.domain.repository.TimerRepository

interface GetTimerSummariesUseCase : UseCaseResultNoParams<List<TimerSummary>>

internal class GetTimerSummariesUseCaseImpl(
    private val authRepository: AuthRepository,
    private val timerRepository: TimerRepository
) : GetTimerSummariesUseCase {
    override suspend fun invoke(): Result<List<TimerSummary>> =
        Result.Success(
        listOf(
            TimerSummary(
                component = TimerSummaryComponent.Today,
                interval = 12134
            ),
            TimerSummary(
                component = TimerSummaryComponent.ThisWeek,
                interval = 123456
            )
        )
    )
}