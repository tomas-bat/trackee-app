package app.trackee.backend.data.util

import app.trackee.backend.domain.model.entry.TimerEntryPreview
import kotlinx.datetime.*
import java.time.format.DateTimeFormatter

val Instant.asCsvDate: String
    get() {
        val zone = TimeZone.currentSystemDefault()

        val formatter = DateTimeFormatter
            .ofPattern("dd/MM/YYYY")
            .withZone(zone.toJavaZoneId())

        return this.toLocalDateTime(zone).toJavaLocalDateTime().format(formatter)
    }

val Instant.asCsvTime: String
    get() {
        val zone = TimeZone.currentSystemDefault()

        val formatter = DateTimeFormatter
            .ofPattern("HH:mm:ss")
            .withZone(zone.toJavaZoneId())

        return this.toLocalDateTime(zone).toJavaLocalDateTime().format(formatter)
    }

val Instant.asClockifyDate: String
    get() {
        val zone = TimeZone.UTC

        val formatter = DateTimeFormatter
            .ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'")
            .withZone(zone.toJavaZoneId())

        return this.toLocalDateTime(zone).toJavaLocalDateTime().format(formatter)
    }

val TimerEntryPreview.durationHours: String
    get() {
        val duration = endedAt - startedAt
        val seconds = duration.inWholeSeconds
        val hours = seconds / 3600
        val minutes = (seconds % 3600) / 60
        val remainingSeconds = seconds % 60

        return String.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }

val TimerEntryPreview.durationDecimal: String
    get() {
        val duration = endedAt - startedAt
        val minutes = duration.inWholeMinutes

        return String.format("%.2f", minutes / 60.0)
    }