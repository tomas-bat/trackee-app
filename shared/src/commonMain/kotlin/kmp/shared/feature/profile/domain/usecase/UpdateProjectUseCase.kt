package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.Project

/**
 * Update a project
 *
 * **Input**: UpdateProjectUseCase.Params
 *
 * **Returns**: Unit
 */
interface UpdateProjectUseCase : UseCaseResult<UpdateProjectUseCase.Params, Unit> {
    /**
     * @param originalProjectId Original client ID of the project (the client ID this project had
     * before it was updated). If the client ID was not changed, it will be the same as project.clientId.
     * @param project The project to be updated
     */
    data class Params(
        val originalClientId: String,
        val project: Project
    )
}

internal class UpdateProjectUseCaseImpl(
    private val profileRepository: ProfileRepository
) : UpdateProjectUseCase {
    override suspend fun invoke(params: UpdateProjectUseCase.Params): Result<Unit> =
        profileRepository.updateProject(params.originalClientId, params.project)
}