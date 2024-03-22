package kmp.shared.feature.timer

import kmp.shared.feature.timer.data.repository.TimerRepositoryImpl
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kmp.shared.feature.timer.domain.usecase.GetTimerEntriesUseCase
import kmp.shared.feature.timer.domain.usecase.GetTimerEntriesUseCaseImpl
import kmp.shared.feature.timer.domain.usecase.GetTimerSummariesUseCase
import kmp.shared.feature.timer.domain.usecase.GetTimerSummariesUseCaseImpl
import kmp.shared.feature.timer.infrastructure.source.RemoteTimerSource
import org.koin.core.module.dsl.factoryOf
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val timerModule = module {
    singleOf(::RemoteTimerSource) bind TimerSource::class

    single {
        TimerRepositoryImpl(
            timerSource = get()
        )
    } bind TimerRepository::class

    factoryOf(::GetTimerEntriesUseCaseImpl) bind GetTimerEntriesUseCase::class
    factoryOf(::GetTimerSummariesUseCaseImpl) bind GetTimerSummariesUseCase::class
}