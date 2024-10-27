package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface GetHasFullAccessUseCase : UseCaseResultNoParams<Boolean>

internal class GetHasFullAccessUseCaseImpl(
    private val repository: PurchaseRepository
) : GetHasFullAccessUseCase {
    override suspend fun invoke(): Result<Boolean> =
        repository.readHasFullAccess()
}