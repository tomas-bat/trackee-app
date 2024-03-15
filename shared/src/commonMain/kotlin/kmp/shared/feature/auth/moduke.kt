package kmp.shared.feature.auth

import kmp.shared.feature.auth.data.repository.AuthRepositoryImpl
import kmp.shared.feature.auth.domain.repository.AuthRepository
import kmp.shared.feature.auth.domain.usecase.LoginWithCredentialsUseCase
import kmp.shared.feature.auth.domain.usecase.LoginWithCredentialsUseCaseImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val authModule = module {
    single {
        AuthRepositoryImpl(
            appleSignInProvider = get(),
            authProvider = get()
        )
    } bind AuthRepository::class

    factoryOf(::LoginWithCredentialsUseCaseImpl) bind LoginWithCredentialsUseCase::class
}