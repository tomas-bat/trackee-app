package app.trackee.backend.presentation.model.user

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.presentation.model.timer.TimerDataDto
import app.trackee.backend.presentation.model.timer.toDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class UserDto(
    val uid: String,
    @SerialName("timer_data") val timerData: TimerDataDto?
)

internal fun User.toDto() = UserDto(
    uid = uid,
    timerData = timerData?.toDto()
)