package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface GetAlphaHasFullAccessUseCase : UseCaseResultNoParams<Boolean>

internal class GetAlphaHasFullAccessUseCaseImpl(
    private val repository: PurchaseRepository
) : GetAlphaHasFullAccessUseCase {
    override suspend fun invoke(): Result<Boolean> =
        repository.readHasFullAccess()
}