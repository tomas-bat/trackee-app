package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.error.domain.ProfileError
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.getOrNull
import kmp.shared.feature.profile.domain.model.NewProject
import kmp.shared.feature.profile.domain.repository.ProfileRepository

/**
 * Add a new project and assign it to the current user
 *
 * **Input**: AddAndAssignProjectUseCase.Params
 *
 * **Returns**: Unit
 */
interface AddAndAssignProjectUseCase : UseCaseResult<AddAndAssignProjectUseCase.Params, Unit> {
    /**
     * @param project The new project
     */
    data class Params(
        val project: NewProject
    )
}

internal class AddAndAssignProjectUseCaseImpl(
    private val profileRepository: ProfileRepository
) : AddAndAssignProjectUseCase {
    override suspend fun invoke(params: AddAndAssignProjectUseCase.Params): Result<Unit> {
        val response = profileRepository.createProject(params.project).getOrNull()
            ?: return Result.Error(ProfileError.FailedToCreateProject())

        return profileRepository.assignProjectToUser(response.clientId, response.projectId)
    }
}
