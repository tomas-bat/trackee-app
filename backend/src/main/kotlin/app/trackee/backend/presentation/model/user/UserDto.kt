package app.trackee.backend.presentation.model.user

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.presentation.model.timer.TimerDataDto
import app.trackee.backend.presentation.model.timer.toDto
import kotlinx.serialization.Serializable

@Serializable
internal data class UserDto(
    val uid: String,
    val timer_data: TimerDataDto?,
    val client_ids: List<String>
)

internal fun User.toDto() = UserDto(
    uid = uid,
    timer_data = timerData?.toDto(),
    client_ids = clientIds
)