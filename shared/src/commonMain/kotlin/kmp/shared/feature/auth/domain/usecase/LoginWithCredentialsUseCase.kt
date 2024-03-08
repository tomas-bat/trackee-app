package kmp.shared.feature.auth.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.auth.domain.model.LoginResponse
import kmp.shared.feature.auth.domain.repository.AuthRepository

interface LoginWithCredentialsUseCase : UseCaseResult<LoginWithCredentialsUseCase.Params, LoginResponse> {
    data class Params(
        val username: String,
        val password: String
    )
}

internal class LoginWithCredentialsUseCaseImpl(
    authRepository: AuthRepository
) : LoginWithCredentialsUseCase {
    override suspend fun invoke(params: LoginWithCredentialsUseCase.Params): Result<LoginResponse> {
        TODO("Not yet implemented")
    }
}