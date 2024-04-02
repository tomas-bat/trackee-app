package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.Client

/**
 * Get clients for the signed user
 *
 * **Returns:** List<Client>
 */
interface GetClientsUseCase : UseCaseResultNoParams<List<Client>>

internal class GetClientsUseCaseImpl(
    private val profileRepository: ProfileRepository
) : GetClientsUseCase {
    override suspend fun invoke(): Result<List<Client>> =
        profileRepository.readClients()
}