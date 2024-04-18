package kmp.shared.feature.intent.infrastructure.source

import io.ktor.client.*
import io.ktor.client.request.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.feature.intent.data.source.RemoteIntentSource
import kmp.shared.feature.intent.domain.model.StartTimerBody
import kmp.shared.feature.intent.infrastructure.model.toDto

internal class RemoteIntentSourceImpl(
    private val client: HttpClient
) : RemoteIntentSource {
    override suspend fun startTimer(body: StartTimerBody): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("user/timer/start") {
                setBody(body.toDto())
            }
            Result.Success(Unit)
        }

    override suspend fun stopTimer(): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.post("user/timer/save_and_stop")
            Result.Success(Unit)
        }

    override suspend fun cancelTimer(): Result<Unit> =
        runCatchingCommonNetworkExceptions {
            client.put("user/timer/cancel")
            Result.Success(Unit)
        }
}