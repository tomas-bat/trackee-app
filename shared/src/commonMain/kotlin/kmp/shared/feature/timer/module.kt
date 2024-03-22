package kmp.shared.feature.timer

import kmp.shared.feature.timer.data.repository.TimerRepositoryImpl
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kmp.shared.feature.timer.domain.usecase.GetTimerEntriesUseCase
import kmp.shared.feature.timer.domain.usecase.GetTimerEntriesUseCaseImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val timerModule = module {
    single {
        TimerRepositoryImpl(
            timerSource = get()
        )
    } bind TimerRepository::class

    factoryOf(::GetTimerEntriesUseCaseImpl) bind GetTimerEntriesUseCase::class
}