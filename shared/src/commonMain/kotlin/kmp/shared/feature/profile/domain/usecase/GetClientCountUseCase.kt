package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Get client count for the signed user
 *
 * **Returns:** Long
 */
interface GetClientCountUseCase : UseCaseResultNoParams<Long>

internal class GetClientCountUseCaseImpl(
    private val repository: ProfileRepository
) : GetClientCountUseCase {
    override suspend fun invoke(): Result<Long> =
        repository.readClientCount()
}