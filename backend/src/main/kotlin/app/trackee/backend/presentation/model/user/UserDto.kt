package app.trackee.backend.presentation.model.user

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.presentation.model.entry.TimerEntryDto
import app.trackee.backend.presentation.model.entry.toDto
import app.trackee.backend.presentation.model.timer.TimerDataDto
import app.trackee.backend.presentation.model.timer.toDto
import kotlinx.serialization.Serializable

@Serializable
internal data class UserDto(
    val uid: String,
    val timer: TimerDataDto?,
    val entries: List<TimerEntryDto>
)

internal fun User.toDto() = UserDto(
    uid = uid,
    timer = timer?.toDto(),
    entries = entries.map { it.toDto() }
)