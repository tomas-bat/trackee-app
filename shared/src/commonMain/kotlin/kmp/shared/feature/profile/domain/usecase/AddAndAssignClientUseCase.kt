package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.error.domain.ProfileError
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.getOrNull
import kmp.shared.feature.profile.domain.model.NewClient
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Add a new client and assign it to the current user
 *
 * **Input**: AddAndAssignClientUseCase.Params
 *
 * **Returns**: Unit
 */
interface AddAndAssignClientUseCase : UseCaseResult<AddAndAssignClientUseCase.Params, Unit> {
    /**
     * @param client The new client
     */
    data class Params(
        val client: NewClient
    )
}

internal class AddAndAssignClientUseCaseImpl(
    private val profileRepository: ProfileRepository
) : AddAndAssignClientUseCase {
    override suspend fun invoke(params: AddAndAssignClientUseCase.Params): Result<Unit> {
        val clientId = profileRepository.createClient(params.client).getOrNull()?.clientId
            ?: return Result.Error(ProfileError.FailedToCreateClient())

        return profileRepository.assignClientToUser(clientId)
    }
}