package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.Client

/**
 * Updates a client
 *
 * **Input**: UpdateClientUseCase.Params
 *
 * **Returns**: Unit
 */
interface UpdateClientUseCase : UseCaseResult<UpdateClientUseCase.Params, Unit> {
    /**
     * @param client The client to be updated
     */
    data class Params(
        val client: Client
    )
}

internal class UpdateClientUseCaseImpl(
    private val profileRepository: ProfileRepository
) : UpdateClientUseCase {
    override suspend fun invoke(params: UpdateClientUseCase.Params): Result<Unit> =
        profileRepository.updateClient(params.client)
}