package kmp.shared.feature.user.domain.model

import kmp.shared.feature.timer.domain.model.TimerData
import kmp.shared.feature.timer.domain.model.TimerEntry

data class User(
    val uid: String,
    val timer: TimerData?,
    val entries: List<TimerEntry>
)