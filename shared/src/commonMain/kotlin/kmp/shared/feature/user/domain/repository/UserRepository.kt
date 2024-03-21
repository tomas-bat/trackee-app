package kmp.shared.feature.user.domain.repository

import kmp.shared.feature.timer.domain.model.TimerEntry
import kmp.shared.base.Result

internal interface UserRepository {
    suspend fun readTimerEntries(
        uid: String
    ): Result<List<TimerEntry>>
}