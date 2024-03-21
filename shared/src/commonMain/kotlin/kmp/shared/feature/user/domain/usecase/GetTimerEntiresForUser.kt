package kmp.shared.feature.user.domain.usecase

import kmp.shared.base.Result
import kmp.shared.base.usecase.UseCaseResult
import kmp.shared.feature.timer.domain.model.TimerEntry
import kmp.shared.feature.user.domain.repository.UserRepository

/**
 * Get timer entries for a specific user.
 *
 * **Input** GetTimerEntiresForUser.Params
 *
 * **Returns** List<TimerEntry>
 */
interface GetTimerEntiresForUserUseCase : UseCaseResult<GetTimerEntiresForUserUseCase.Params, List<TimerEntry>> {
    data class Params(
        val uid: String
    )
}

internal class GetTimerEntiresForUserUseCaseImpl(
    private val repository: UserRepository
) : GetTimerEntiresForUserUseCase {
    override suspend fun invoke(params: GetTimerEntiresForUserUseCase.Params): Result<List<TimerEntry>> =
        repository.readTimerEntries(params.uid)
}