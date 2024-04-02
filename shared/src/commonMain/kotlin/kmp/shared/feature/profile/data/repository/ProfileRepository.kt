package kmp.shared.feature.profile.data.repository

import kmp.shared.base.Result
import kmp.shared.base.util.extension.map
import kmp.shared.feature.profile.data.source.RemoteProfileSource
import kmp.shared.feature.profile.domain.repository.ProfileRepository
import kmp.shared.feature.timer.domain.model.Client
import kmp.shared.feature.timer.infrastructure.model.toDomain

internal class ProfileRepositoryImpl(
    private val source: RemoteProfileSource
) : ProfileRepository {
    override suspend fun readClients(): Result<List<Client>> =
        source.readClients().map { list -> list.map { it.toDomain() } }
}