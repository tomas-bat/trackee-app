package kmp.shared.feature.profile.infrastructure.source

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import kmp.shared.base.Result
import kmp.shared.base.error.util.runCatchingCommonNetworkExceptions
import kmp.shared.feature.profile.data.source.RemoteProfileSource
import kmp.shared.feature.timer.infrastructure.model.ClientDto

internal class RemoteProfileSourceImpl(
    private val client: HttpClient
) : RemoteProfileSource {
    override suspend fun readClients(): Result<List<ClientDto>> =
        runCatchingCommonNetworkExceptions {
            val res = client.get("/user/clients")
            res.body<List<ClientDto>>()
        }
}