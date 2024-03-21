package kmp.shared.feature.user.infrastructure.source

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.feature.timer.infrastructure.model.TimerEntryDto
import kmp.shared.feature.user.data.source.UserSource

internal class RemoteUserSourceImpl(
    private val client: HttpClient
) : UserSource {
    override suspend fun readTimerEntries(uid: String): Result<List<TimerEntryDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("user/${uid}/entries")
            res.body<List<TimerEntryDto>>()
        }
}