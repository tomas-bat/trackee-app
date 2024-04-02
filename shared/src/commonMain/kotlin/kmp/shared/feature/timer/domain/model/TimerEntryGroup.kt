package kmp.shared.feature.timer.domain.model

import kotlinx.datetime.LocalDate

data class TimerEntryGroup(
    val date: LocalDate,
    val entries: List<TimerEntryPreview>
)