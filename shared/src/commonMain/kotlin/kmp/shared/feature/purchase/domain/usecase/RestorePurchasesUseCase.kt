package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface RestorePurchasesUseCase : UseCaseResultNoParams<Unit>

internal class RestorePurchasesUseCaseImpl(
    private val repository: PurchaseRepository
) : RestorePurchasesUseCase {
    override suspend fun invoke(): Result<Unit> =
        repository.restorePurchases()
}