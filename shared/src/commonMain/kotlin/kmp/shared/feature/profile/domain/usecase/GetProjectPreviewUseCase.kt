package kmp.shared.feature.profile.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.ProjectPreview

/**
 * Returns a ProejctPreview by a given project ID and client ID
 *
 * **Input**: GetProjectPreviewUseCase.Params
 *
 * **Returns**: Unit
 */
interface GetProjectPreviewUseCase : UseCaseResult<GetProjectPreviewUseCase.Params, ProjectPreview> {
    /**
     * @param clientId Client ID
     * @param projectId Project ID
     */
    data class Params(
        val clientId: String,
        val projectId: String
    )
}

internal class GetProjectPreviewUseCaseImpl(
    private val profileRepository: ProfileRepository
) : GetProjectPreviewUseCase {
    override suspend fun invoke(params: GetProjectPreviewUseCase.Params): Result<ProjectPreview> =
        profileRepository.readProjectPreview(params.clientId, params.projectId)
}