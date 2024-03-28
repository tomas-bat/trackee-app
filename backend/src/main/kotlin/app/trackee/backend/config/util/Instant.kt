package app.trackee.backend.config.util

import com.google.cloud.Timestamp
import kotlinx.datetime.Instant
import java.util.*

fun Instant.toTimestamp(): Timestamp {
    val javaInstant = java.time.Instant.ofEpochMilli(this.toEpochMilliseconds())
    val javaDate = Date.from(javaInstant)
    return Timestamp.of(javaDate)
}