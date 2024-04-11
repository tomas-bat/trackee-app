package app.trackee.backend.presentation.model.timer

import app.trackee.backend.domain.model.timer.TimerSummary
import kotlinx.serialization.Serializable

@Serializable
internal data class TimerSummaryDto(
    val component: String,
    val interval: Long
)

internal fun TimerSummary.toDto() = TimerSummaryDto(
    component = component.rawValue,
    interval = interval
)