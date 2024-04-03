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
     * @param project The project to be updated
     */
    data class Params(
        val project: Project
    )
}

internal class UpdateProjectUseCaseImpl(
    private val profileRepository: ProfileRepository
) : UpdateProjectUseCase {
    override suspend fun invoke(params: UpdateProjectUseCase.Params): Result<Unit> =
        profileRepository.updateProject(params.project)
}