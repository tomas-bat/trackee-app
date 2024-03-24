package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.base.util.extension.getOrNull
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.domain.model.TimerDataPreview
import kmp.shared.feature.timer.domain.model.TimerType
import kmp.shared.feature.timer.domain.repository.TimerRepository

interface GetTimerDataPreviewUseCase : UseCaseResultNoParams<TimerDataPreview>

internal class GetTimerDataPreviewUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerDataPreviewUseCase {
    override suspend fun invoke(): Result<TimerDataPreview> =
        timerRepository.readTimerData().map { data ->
            val client = data.clientId?.let { clientId ->
                timerRepository.readClient(clientId).getOrNull()
            }

            val project = client?.id?.let { clientId ->
                data.projectId?.let { projectId ->
                    timerRepository.readProject(clientId, projectId).getOrNull()
                }
            }

            return Result.Success(TimerDataPreview(
                status = data.status,
                type = TimerType.Timer, // TODO: remember last type
                client = client,
                project = project,
                description = data.description,
                startedAt = data.startedAt,
                availableProjects = timerRepository.readAllProjects().getOrNull() ?: emptyList()
            ))

        }
}