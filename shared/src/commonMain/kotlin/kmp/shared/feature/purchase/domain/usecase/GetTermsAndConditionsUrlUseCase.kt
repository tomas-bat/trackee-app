package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface GetTermsAndConditionsUrlUseCase : UseCaseResultNoParams<String>

internal class GetTermsAndConditionsUrlUseCaseImpl(
    private val repository: PurchaseRepository
) : GetTermsAndConditionsUrlUseCase {
    override suspend fun invoke(): Result<String> =
        repository.getTermsAndConditionsUrl()
}