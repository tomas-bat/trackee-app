package kmp.shared.feature.user.data.repository

import kmp.shared.base.Result
import kmp.shared.base.util.extension.map
import kmp.shared.feature.timer.domain.model.TimerEntry
import kmp.shared.feature.timer.infrastructure.model.toDomain
import kmp.shared.feature.user.data.source.UserSource
import kmp.shared.feature.user.domain.repository.UserRepository

internal class UserRepositoryImpl(
    private val userSource: UserSource
) : UserRepository {
    override suspend fun readTimerEntries(uid: String): Result<List<TimerEntry>> =
        userSource.readTimerEntries(uid).map { list -> list.map { entry -> entry.toDomain() } }
}