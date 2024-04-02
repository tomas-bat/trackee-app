package kmp.shared.feature.profile.domain.repository

import kmp.shared.base.Result
import kmp.shared.feature.timer.domain.model.Client

internal interface ProfileRepository {
    suspend fun readClients(): Result<List<Client>>
}