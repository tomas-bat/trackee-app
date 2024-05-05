package kmp.shared.feature.integration

import kmp.shared.feature.integration.data.repository.IntegrationRepositoryImpl
import kmp.shared.feature.integration.data.source.RemoteIntegrationSource
import kmp.shared.feature.integration.domain.repository.IntegrationRepository
import kmp.shared.feature.integration.domain.usecase.*
import kmp.shared.feature.integration.infrastructure.source.RemoteIntegrationSourceImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val integrationModule = module {
    singleOf(::RemoteIntegrationSourceImpl) bind RemoteIntegrationSource::class

    single {
        IntegrationRepositoryImpl(
            source = get()
        )
    } bind IntegrationRepository::class

    factoryOf(::AddIntegrationUseCaseImpl) bind AddIntegrationUseCase::class
    factoryOf(::GetIntegrationUseCaseImpl) bind GetIntegrationUseCase::class
    factoryOf(::GetIntegrationsUseCaseImpl) bind GetIntegrationsUseCase::class
    factoryOf(::UpdateIntegrationUseCaseImpl) bind UpdateIntegrationUseCase::class
    factoryOf(::DeleteIntegrationUseCaseImpl) bind DeleteIntegrationUseCase::class
    factoryOf(::ExportToCsvUseCaseImpl) bind ExportToCsvUseCase::class
    factoryOf(::ExportToClockifyUseCaseImpl) bind ExportToClockifyUseCase::class
}