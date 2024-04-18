package kmp.shared.feature.intent

import kmp.shared.feature.intent.data.repository.IntentRepositoryImpl
import kmp.shared.feature.intent.data.source.RemoteIntentSource
import kmp.shared.feature.intent.domain.repository.IntentRepository
import kmp.shared.feature.intent.domain.usecase.*
import kmp.shared.feature.intent.infrastructure.source.RemoteIntentSourceImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val intentModule = module {
    singleOf(::RemoteIntentSourceImpl) bind RemoteIntentSource::class

    single {
        IntentRepositoryImpl(
            source = get()
        )
    } bind IntentRepository::class

    factoryOf(::StartTimerUseCaseImpl) bind StartTimerUseCase::class
    factoryOf(::StopTimerUseCaseImpl) bind StopTimerUseCase::class
    factoryOf(::CancelTimerUseCaseImpl) bind CancelTimerUseCase::class
}