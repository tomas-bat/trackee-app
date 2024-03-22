package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.error.domain.TimerError
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.getOrNull
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.domain.model.TimerEntryPreview
import kmp.shared.feature.timer.domain.repository.TimerRepository

/**
 * Get timer entries for a specific user.
 *
 * **Input** GetTimerEntriesUseCase.Params
 *
 * **Returns** List<TimerEntryPreview>
 */
interface GetTimerEntriesUseCase : UseCaseResult<GetTimerEntriesUseCase.Params, List<TimerEntryPreview>> {
    /**
     * @param uid UID of user
     */
    data class Params(
        val uid: String
    )
}

internal class GetTimerEntriesUseCaseImpl(
    private val repository: TimerRepository
) : GetTimerEntriesUseCase {
    override suspend fun invoke(params: GetTimerEntriesUseCase.Params): Result<List<TimerEntryPreview>> =
        repository.readEntries(params.uid).map { entries ->
            entries.map { entry ->
                val client = repository.readClient(entry.clientId).getOrNull()
                    ?: return Result.Error(TimerError.ClientNotFound("clientId=${entry.clientId}"))

                val project = repository.readProject(entry.clientId, entry.projectId).getOrNull()
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