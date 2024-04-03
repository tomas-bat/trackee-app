package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Remove a project, together with all entries belonging to it
 *
 * **Input**: RemoveProjectUseCase.Params
 *
 * **Returns**: Unit
 */
interface RemoveProjectUseCase : UseCaseResult<RemoveProjectUseCase.Params, Unit> {
    /**
     * @param clientId ID of the client this project belongs to
     * @param projectId ID of the project to be removed
     */
    data class Params(
        val clientId: String,
        val projectId: String
    )
}

internal class RemoveProjectUseCaseImpl(
    private val profileRepository: ProfileRepository
) : RemoveProjectUseCase {
    override suspend fun invoke(params: RemoveProjectUseCase.Params): Result<Unit> =
        profileRepository.deleteProject(params.clientId, params.projectId)
}