package kmp.shared.feature.timer.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResultNoParams
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.domain.model.TimerEntryGroup
import kmp.shared.feature.timer.domain.repository.TimerRepository
import kotlinx.datetime.Clock
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime

/**
 * Get timer entries for the signed user
 *
 * **Returns** List<TimerEntryPreview>
 */
interface GetTimerEntriesUseCase : UseCaseResultNoParams<List<TimerEntryGroup>>

internal class GetTimerEntriesUseCaseImpl(
    private val timerRepository: TimerRepository
) : GetTimerEntriesUseCase {
    override suspend fun invoke(): Result<List<TimerEntryGroup>> =
        timerRepository.readEntryPreviews()
            .map { entries ->
                val groups = entries
                    .groupBy { it.startedAt.toLocalDateTime(TimeZone.currentSystemDefault()).date }
                    .toList()
                    .map { pair ->
                        TimerEntryGroup(pair.first, pair.second.sortedBy { it.startedAt })
                    }
                    .toMutableList()

                val today = Clock.System.now().toLocalDateTime(TimeZone.currentSystemDefault()).date

                if (groups.firstOrNull { it.date == today } == null) {
                    groups += TimerEntryGroup(
                        date = today,
                        entries = emptyList()
                    )
                }

               groups.toList().sortedBy { it.date }
            }
}