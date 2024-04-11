package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.feature.timer.domain.model.TimerSummary
import kmp.shared.feature.timer.domain.model.TimerSummaryComponent
import kotlinx.serialization.Serializable

@Serializable
data class TimerSummaryDto(
    val component: String,
    val interval: Long
)

fun TimerSummaryDto.toDomain() =
    TimerSummaryComponent.entries.firstOrNull { it.rawValue == component }?.let { component ->
        TimerSummary(
            component = component,
            interval = interval
        )
    }