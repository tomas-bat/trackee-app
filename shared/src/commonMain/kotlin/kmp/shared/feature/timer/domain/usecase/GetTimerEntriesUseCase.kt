package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.error.domain.TimerError
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.base.util.extension.getOrNull
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.domain.model.TimerEntryPreview
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Get timer entries for the current user.
 *
 * **Returns** List<TimerEntryPreview>
 */
interface GetTimerEntriesUseCase : UseCaseResultNoParams<List<TimerEntryPreview>>

internal class GetTimerEntriesUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerEntriesUseCase {
    override suspend fun invoke(): Result<List<TimerEntryPreview>> =
        timerRepository.readEntries().map { entries ->
            entries.map { entry ->
                val client = timerRepository.readClient(entry.clientId).getOrNull()
                    ?: return Result.Error(TimerError.ClientNotFound("clientId=${entry.clientId}"))

                val project = timerRepository.readProject(entry.clientId, entry.projectId).getOrNull()
                    ?: return Result.Error(
                        TimerError.ProjectNotFound("clientId=${entry.clientId}, projectId=${entry.projectId}")
                    )

                TimerEntryPreview(
                    id = entry.id,
                    project = project,
                    client = client,
                    description = entry.description,
                    startedAt = entry.startedAt,
                    endedAt = entry.endedAt
                )
            }
    }
}