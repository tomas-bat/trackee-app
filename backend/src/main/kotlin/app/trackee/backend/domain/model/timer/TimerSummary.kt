package app.trackee.backend.domain.model.timer

enum class TimerSummaryComponent(
    val rawValue: String
) {
    Today("today"),
    ThisWeek("this_week")
}

data class TimerSummary(
    val component: TimerSummaryComponent,
    val interval: Long
)