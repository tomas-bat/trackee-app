package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.feature.timer.domain.model.ProjectPreview
import kmp.shared.feature.timer.domain.repository.TimerRepository

interface GetProjectsUseCase : UseCaseResultNoParams<List<ProjectPreview>>

internal class GetProjectsUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetProjectsUseCase {
    override suspend fun invoke(): Result<List<ProjectPreview>> =
        timerRepository.readAllProjectPreviews()
}