package app.trackee.backend.infrastructure.model.clockify

import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyError(
    val message: String,
    val code: Int
)
