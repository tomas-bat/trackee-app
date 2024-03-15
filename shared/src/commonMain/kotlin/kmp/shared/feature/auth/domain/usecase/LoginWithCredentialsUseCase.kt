package kmp.shared.feature.auth.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.error.domain.AuthError
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.toEmptyResult
import kmp.shared.feature.auth.domain.repository.AuthRepository

interface LoginWithCredentialsUseCase : UseCaseResult<LoginWithCredentialsUseCase.Params, Unit> {
    data class Params(
        val username: String,
        val password: String
    )
}

internal class LoginWithCredentialsUseCaseImpl(
    private val authRepository: AuthRepository
) : LoginWithCredentialsUseCase {
    override suspend fun invoke(params: LoginWithCredentialsUseCase.Params): Result<Unit> {
        if (params.username.isEmpty() || params.password.isEmpty()) {
            return Result.Error(AuthError.EmptyField())
        }

        return authRepository.loginWithCredentials(params.username, params.password).toEmptyResult()
    }
}