package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.purchase.domain.model.PurchasePackage
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface GetPurchasePackagesUseCase : UseCaseResultNoParams<List<PurchasePackage>>

internal class GetPurchasePackagesUseCaseImpl(
    private val repository: PurchaseRepository
) : GetPurchasePackagesUseCase {
    override suspend fun invoke(): Result<List<PurchasePackage>> =
        repository.readPackages()
}