package app.trackee.backend.domain.model.user

import app.trackee.backend.domain.model.timer.TimerData

data class User(
    val uid: String,
    val timerData: TimerData?,
    val clientIds: List<String>
)