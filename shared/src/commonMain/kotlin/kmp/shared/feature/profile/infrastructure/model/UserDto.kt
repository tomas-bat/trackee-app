package kmp.shared.feature.profile.infrastructure.model

import kmp.shared.feature.timer.infrastructure.model.TimerDataDto
import kmp.shared.feature.timer.infrastructure.model.toDomain
import kmp.shared.feature.profile.domain.model.User
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class UserDto(
    val uid: String,
    @SerialName("timer_data") val timerData: TimerDataDto?
)

internal fun UserDto.toDomain() = User(
    uid = uid,
    timerData = timerData?.toDomain()
)

