package kmp.shared.feature.user.infrastructure.model

import kmp.shared.feature.timer.infrastructure.model.TimerDataDto
import kmp.shared.feature.timer.infrastructure.model.TimerEntryDto
import kmp.shared.feature.timer.infrastructure.model.toDomain
import kmp.shared.feature.user.domain.model.User

internal data class UserDto(
    val timer: TimerDataDto,
    val entries: List<TimerEntryDto>
)

internal fun UserDto.toDomain(uid: String) = User(
    uid = uid,
    timer = timer.toDomain(),
    entries = entries.map { it.toDomain() }
)

