package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface GetIsPackageEligibleForIntroductoryDiscountUseCase : UseCaseResult<GetIsPackageEligibleForIntroductoryDiscountUseCase.Params, Boolean> {
    data class Params(
        val packageId: String
    )
}

internal class GetIsPackageEligibleForIntroductoryDiscountUseCaseImpl(
    private val repository: PurchaseRepository
) : GetIsPackageEligibleForIntroductoryDiscountUseCase {
    override suspend fun invoke(params: GetIsPackageEligibleForIntroductoryDiscountUseCase.Params): Result<Boolean> =
        repository.readIsPackageEligibleForIntroductoryDiscount(params.packageId)
}