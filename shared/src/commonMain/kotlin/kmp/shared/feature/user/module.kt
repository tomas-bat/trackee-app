package kmp.shared.feature.user

import kmp.shared.feature.user.data.repository.UserRepositoryImpl
import kmp.shared.feature.user.domain.repository.UserRepository
import kmp.shared.feature.user.domain.usecase.GetTimerEntiresForUserUseCase
import kmp.shared.feature.user.domain.usecase.GetTimerEntiresForUserUseCaseImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val userModule = module {
    single {
        UserRepositoryImpl(
            userSource = get()
        )
    } bind UserRepository::class

    factoryOf(::GetTimerEntiresForUserUseCaseImpl) bind GetTimerEntiresForUserUseCase::class
}