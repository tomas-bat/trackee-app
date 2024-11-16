package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface PurchasePackageUseCase : UseCaseResult<PurchasePackageUseCase.Params, Unit> {
    data class Params(
        val packageId: String
    )
}

internal class PurchasePackageUseCaseImpl(
    private val repository: PurchaseRepository
) : PurchasePackageUseCase {
    override suspend fun invoke(params: PurchasePackageUseCase.Params): Result<Unit> =
        repository.purchasePackage(params.packageId)
}