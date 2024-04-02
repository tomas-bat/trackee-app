package kmp.shared.feature.profile

import kmp.shared.feature.profile.data.repository.ProfileRepositoryImpl
import kmp.shared.feature.profile.data.source.RemoteProfileSource
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.profile.domain.usecase.GetClientsUseCase
import kmp.shared.feature.profile.domain.usecase.GetClientsUseCaseImpl
import kmp.shared.feature.profile.infrastructure.source.RemoteProfileSourceImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val profileModule = module {
    singleOf(::RemoteProfileSourceImpl) bind RemoteProfileSource::class

    single {
        ProfileRepositoryImpl(
            source = get()
        )
    } bind ProfileRepository::class

    factoryOf(::GetClientsUseCaseImpl) bind GetClientsUseCase::class
}