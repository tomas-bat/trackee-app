package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.Client

/**
 * Returns a client by a given ID
 *
 * **Input**: GetClientUseCase.Params
 *
 * **Returns**: Unit
 */
interface GetClientUseCase : UseCaseResult<GetClientUseCase.Params, Client> {
    /**
     * @param clientId The client ID
     */
    data class Params(
        val clientId: String
    )
}

internal data class GetClientUseCaseImpl(
    private val profileRepository: ProfileRepository
) : GetClientUseCase {
    override suspend fun invoke(params: GetClientUseCase.Params): Result<Client> =
        profileRepository.readClient(params.clientId)
}