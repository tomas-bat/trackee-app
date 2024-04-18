package kmp.shared.feature.intent.data.repository

import kmp.shared.base.Result
import kmp.shared.feature.intent.data.source.RemoteIntentSource
import kmp.shared.feature.intent.domain.model.StartTimerBody
import kmp.shared.feature.intent.domain.repository.IntentRepository

internal class IntentRepositoryImpl(
    private val source: RemoteIntentSource
) : IntentRepository {
    override suspend fun startTimer(body: StartTimerBody): Result<Unit> =
        source.startTimer(body)

    override suspend fun stopTimer(): Result<Unit> =
        source.stopTimer()

    override suspend fun cancelTimer(): Result<Unit> =
        source.cancelTimer()
}