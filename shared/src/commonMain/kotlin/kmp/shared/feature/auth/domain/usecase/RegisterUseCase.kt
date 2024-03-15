package kmp.shared.feature.auth.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.error.domain.AuthError
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.toEmptyResult
import kmp.shared.feature.auth.domain.repository.AuthRepository

interface RegisterUseCase : UseCaseResult<RegisterUseCase.Params, Unit> {
    data class Params(
        val username: String,
        val newPassword: String,
        val verifyPassword: String
    )
}

internal class RegisterUseCaseImpl(
    private val authRepository: AuthRepository
) : RegisterUseCase {
    override suspend fun invoke(params: RegisterUseCase.Params): Result<Unit> {
        if (
            params.username.isEmpty()
            || params.newPassword.isEmpty()
            || params.verifyPassword.isEmpty()
            ) {
            return Result.Error(AuthError.EmptyField())
        }

        if (params.newPassword != params.verifyPassword) {
            return Result.Error(AuthError.PasswordsDontMatch())
        }

        return authRepository.createUser(params.username, params.newPassword).toEmptyResult()
    }
}