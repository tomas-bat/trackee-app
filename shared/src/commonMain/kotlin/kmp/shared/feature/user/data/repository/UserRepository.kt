package kmp.shared.feature.user.data.repository

import kmp.shared.feature.user.data.source.UserSource
import kmp.shared.feature.user.domain.repository.UserRepository

internal class UserRepositoryImpl(
    private val userSource: UserSource
) : UserRepository {

}