package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.domain.model.TimerEntryGroup
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime

/**
 * Get timer entries for the signed user
 *
 * **Returns** List<TimerEntryPreview>
 */
interface GetTimerEntriesUseCase : UseCaseResult<GetTimerEntriesUseCase.Params, List<TimerEntryGroup>> {
    /**
     * @param startAfter An instant after which the entries should be fetched.
     * If `null`, the start time will be now.
     * @param limit Paging limit of entries. If `null`, no limit will be applied.
     * @param endAt An instant until which the entries should be. If `null`, the end time will be a distant past.
     *
     * Use `startAfter` and `limit` for regular paging usage. Use `endAt` to get all entries until an instant.
     * If all params are null, all entries will be fetched.
     */
    data class Params(
        val startAfter: Instant? = null,
        val limit: Int? = null,
        val endAt: Instant? = null
    ) {
        constructor(limit: Int?) : this(null, limit, null)

        constructor(startAfter: Instant?, limit: Int?) : this(startAfter, limit, null)
    }
}

internal class GetTimerEntriesUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerEntriesUseCase {
    override suspend fun invoke(params: GetTimerEntriesUseCase.Params): Result<List<TimerEntryGroup>> =
        timerRepository.readEntryPreviews(
            startAfter = params.startAfter,
            limit = params.limit,
            endAt = params.endAt
        )
        .map { entries ->
            val groups = entries
                .groupBy { it.startedAt.toLocalDateTime(TimeZone.currentSystemDefault()).date }
                .toList()
                .map { pair ->
                    TimerEntryGroup(pair.first, pair.second.sortedBy { it.startedAt })
                }
                .toMutableList()

            val today = Clock.System.now().toLocalDateTime(TimeZone.currentSystemDefault()).date

            if (params.startAfter == null && groups.firstOrNull { it.date == today } == null) {
                groups += TimerEntryGroup(
                    date = today,
                    entries = emptyList()
                )
            }

           groups.toList().sortedBy { it.date }
        }
}