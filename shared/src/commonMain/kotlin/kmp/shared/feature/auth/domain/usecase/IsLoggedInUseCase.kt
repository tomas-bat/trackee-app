package kmp.shared.feature.auth.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.auth.domain.repository.AuthRepository

interface IsLoggedInUseCase : UseCaseResultNoParams<Boolean>

internal class IsLoggedInUseCaseImpl(
    private val authRepository: AuthRepository
) : IsLoggedInUseCase {
    override suspend fun invoke(): Result<Boolean> {
        val result = authRepository.readAccessToken()

        return when (result) {
            is Result.Success -> Result.Success(true)
            else -> Result.Success(false)
        }
    }
}