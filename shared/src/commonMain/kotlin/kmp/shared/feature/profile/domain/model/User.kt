package kmp.shared.feature.profile.domain.model

import kmp.shared.feature.timer.domain.model.TimerData

data class User(
    val uid: String,
    val timerData: TimerData?
)