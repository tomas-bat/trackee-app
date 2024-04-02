package kmp.shared.feature.profile.data.source

import kmp.shared.base.Result
import kmp.shared.feature.timer.infrastructure.model.ClientDto

internal interface RemoteProfileSource {
    suspend fun readClients(): Result<List<ClientDto>>
}