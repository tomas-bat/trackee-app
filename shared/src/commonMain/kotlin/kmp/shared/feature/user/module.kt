package kmp.shared.feature.user

import kmp.shared.feature.user.data.repository.UserRepositoryImpl
import kmp.shared.feature.user.data.source.UserSource
import kmp.shared.feature.user.domain.repository.UserRepository
import kmp.shared.feature.user.infrastructure.source.RemoteUserSource
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val userModule = module {
    singleOf(::RemoteUserSource) bind UserSource::class

    single {
        UserRepositoryImpl(
            userSource = get()
        )
    } bind UserRepository::class

}