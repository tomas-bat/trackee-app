package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyCreateCustomAttributeRequest
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyCreateCustomAttributeRequest(
    val name: String,
    val namespace: String,
    val value: String
)

internal fun ClockifyCreateCustomAttributeRequest.toRaw() = RawClockifyCreateCustomAttributeRequest(
    name = name,
    namespace = namespace,
    value = value
)

internal fun RawClockifyCreateCustomAttributeRequest.toDomain() = ClockifyCreateCustomAttributeRequest(
    name = name,
    namespace = namespace,
    value = value
)