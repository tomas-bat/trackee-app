package app.trackee.backend.domain.model.user

import app.trackee.backend.domain.model.entry.TimeEntry
import app.trackee.backend.domain.model.timer.TimerData

data class User(
    val uid: String,
    val timer: TimerData?,
    val entries: List<TimeEntry>
)