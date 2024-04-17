package kmp.shared.feature.intent.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.intent.domain.model.StartTimerBody

internal interface IntentRepository {
    suspend fun startTimer(body: StartTimerBody): Result<Unit>
}