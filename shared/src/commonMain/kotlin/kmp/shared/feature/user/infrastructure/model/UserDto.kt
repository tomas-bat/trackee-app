package kmp.shared.feature.user.infrastructure.model

import kmp.shared.feature.timer.infrastructure.model.TimerDataDto
import kmp.shared.feature.timer.infrastructure.model.toDomain
import kmp.shared.feature.user.domain.model.User
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class UserDto(
    val uid: String,
    @SerialName("timer_data") val timerData: TimerDataDto?,
    @SerialName("client_ids") val clientIds: List<String>
)

internal fun UserDto.toDomain() = User(
    uid = uid,
    timerData = timerData?.toDomain(),
    clientIds = clientIds
)

