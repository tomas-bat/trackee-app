package kmp.shared.feature.timer

import kmp.shared.feature.timer.data.repository.TimerRepositoryImpl
import kmp.shared.feature.timer.data.source.TimerSource
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kmp.shared.feature.timer.domain.usecase.*
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
    factoryOf(::GetTimerDataPreviewUseCaseImpl) bind GetTimerDataPreviewUseCase::class
    factoryOf(::GetProjectsUseCaseImpl) bind GetProjectsUseCase::class
    factoryOf(::UpdateTimerDataUseCaseImpl) bind UpdateTimerDataUseCase::class
    factoryOf(::AddTimerEntryUseCaseImpl) bind AddTimerEntryUseCase::class
    factoryOf(::DeleteTimerEntryUseCaseImpl) bind DeleteTimerEntryUseCase::class
    factoryOf(::StartTimerUseCaseImpl) bind StartTimerUseCase::class
}