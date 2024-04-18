package kmp.shared.feature.intent.data.source

import kmp.shared.base.Result
import kmp.shared.feature.intent.domain.model.StartTimerBody

internal interface RemoteIntentSource {
    suspend fun startTimer(body: StartTimerBody): Result<Unit>

    suspend fun stopTimer(): Result<Unit>

    suspend fun cancelTimer(): Result<Unit>
}