package kmp.shared.feature.purchase

import kmp.shared.feature.purchase.data.repository.PurchaseRepositoryImpl
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository
import kmp.shared.feature.purchase.domain.usecase.GetHasFullAccessUseCase
import kmp.shared.feature.purchase.domain.usecase.GetHasFullAccessUseCaseImpl
import org.koin.core.module.dsl.factoryOf
import org.koin.dsl.bind
import org.koin.dsl.module

internal val purchaseModule = module {
    single {
        PurchaseRepositoryImpl(
            provider = get()
        )
    } bind PurchaseRepository::class

    factoryOf(::GetHasFullAccessUseCaseImpl) bind GetHasFullAccessUseCase::class
}