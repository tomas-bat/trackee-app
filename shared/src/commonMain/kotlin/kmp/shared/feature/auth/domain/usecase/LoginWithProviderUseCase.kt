package kmp.shared.feature.auth.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.toEmptyResult
import kmp.shared.feature.auth.domain.model.ExternalLoginType
import kmp.shared.feature.auth.domain.repository.AuthRepository

interface LoginWithProviderUseCase : UseCaseResult<LoginWithProviderUseCase.Params, Unit> {
    data class Params(
        val type: ExternalLoginType
    )
}

internal class LoginWithProviderUseCaseImpl(
    private val repository: AuthRepository
) : LoginWithProviderUseCase {
    override suspend fun invoke(params: LoginWithProviderUseCase.Params): Result<Unit> =
        repository.loginWithProvider(
            providerType = params.type,
            retryIfCancelled = true
        ).toEmptyResult()
}