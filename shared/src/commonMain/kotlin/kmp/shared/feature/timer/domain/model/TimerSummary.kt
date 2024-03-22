package kmp.shared.feature.timer.domain.model

enum class TimerSummaryComponent {
    Today, ThisWeek
}

data class TimerSummary(
    val component: TimerSummaryComponent,
    val interval: Long
)