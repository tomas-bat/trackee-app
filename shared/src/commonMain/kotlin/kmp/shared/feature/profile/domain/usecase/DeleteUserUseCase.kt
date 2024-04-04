package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Deletes the signed user.
 *
 * **Returns** Unit
 */
interface DeleteUserUseCase : UseCaseResultNoParams<Unit>

internal class DeleteUserUseCaseImpl(
    private val profileRepository: ProfileRepository
) : DeleteUserUseCase {
    override suspend fun invoke(): Result<Unit> =
        profileRepository.deleteUser()
}