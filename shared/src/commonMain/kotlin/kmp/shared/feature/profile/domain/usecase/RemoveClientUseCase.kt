package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Removes a client, together with all entries and projects belonging to it
 *
 * **Input**: RemoveClientUseCase.Params
 *
 * **Returns**: Unit
 */
interface RemoveClientUseCase : UseCaseResult<RemoveClientUseCase.Params, Unit> {
    /**
     * @param clientId ID of the client to be removed
     */
    data class Params(
        val clientId: String
    )
}

internal class RemoveClientUseCaseImpl(
    private val profileRepository: ProfileRepository
) : RemoveClientUseCase {
    override suspend fun invoke(params: RemoveClientUseCase.Params): Result<Unit> =
        profileRepository.deleteClient(params.clientId)
}

