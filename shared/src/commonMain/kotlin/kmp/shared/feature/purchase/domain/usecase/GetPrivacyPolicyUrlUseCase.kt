package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface GetPrivacyPolicyUrlUseCase : UseCaseResultNoParams<String>

internal class GetPrivacyPolicyUrlUseCaseImpl(
    private val repository: PurchaseRepository
) : GetPrivacyPolicyUrlUseCase {
    override suspend fun invoke(): Result<String> =
        repository.getPrivacyPolicyUrl()
}