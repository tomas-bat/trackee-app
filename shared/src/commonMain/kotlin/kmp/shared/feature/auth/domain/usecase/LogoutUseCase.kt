package kmp.shared.feature.auth.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.base.util.extension.toEmptyResult
import kmp.shared.feature.auth.domain.repository.AuthRepository

interface LogoutUseCase : UseCaseResultNoParams<Unit>

internal class LogoutUseCaseImpl(
    private val authRepository: AuthRepository
) : LogoutUseCase {
    override suspend fun invoke(): Result<Unit> =
        authRepository.logout().toEmptyResult()
}