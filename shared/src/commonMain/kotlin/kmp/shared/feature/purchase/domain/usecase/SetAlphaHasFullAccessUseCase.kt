package kmp.shared.feature.purchase.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.purchase.domain.repository.PurchaseRepository

interface SetAlphaHasFullAccessUseCase : UseCaseResult<SetAlphaHasFullAccessUseCase.Params, Unit> {
    data class Params(
        val alphaHasFullAccess: Boolean
    )
}

internal class SetAlphaHasFullAccessUseCaseImpl(
    private val repository: PurchaseRepository
) : SetAlphaHasFullAccessUseCase {
    override suspend fun invoke(params: SetAlphaHasFullAccessUseCase.Params): Result<Unit> =
        repository.setAlphaHasFullAccess(params.alphaHasFullAccess)
}