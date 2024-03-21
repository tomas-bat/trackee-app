package kmp.shared.feature.user.data.source

import kmp.shared.base.Result
import kmp.shared.feature.timer.infrastructure.model.TimerEntryDto

internal interface UserSource {
    suspend fun readTimerEntries(
        uid: String
    ): Result<List<TimerEntryDto>>
}