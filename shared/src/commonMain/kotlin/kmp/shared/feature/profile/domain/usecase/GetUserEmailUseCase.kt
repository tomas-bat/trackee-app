package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Gets the e-mail address of the signed user.
 * Returns AuthError.NoCurrentUser if no user is signed.
 *
 * **Returns** String
 */
interface GetUserEmailUseCase : UseCaseResultNoParams<String>

internal class GetUserEmailUseCaseImpl(
    private val repository: ProfileRepository
) : GetUserEmailUseCase {
    override suspend fun invoke(): Result<String> =
        repository.readUserEmail()
}