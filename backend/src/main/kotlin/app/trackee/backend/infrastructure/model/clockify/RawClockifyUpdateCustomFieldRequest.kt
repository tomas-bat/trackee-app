package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyUpdateCustomFieldRequest
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyUpdateCustomFieldRequest(
    val customFieldId: String,
    val sourceType: String?,
    @Contextual val value: Any?
)

internal fun ClockifyUpdateCustomFieldRequest.toRaw() = RawClockifyUpdateCustomFieldRequest(
    customFieldId = customFieldId,
    sourceType = sourceType,
    value = value
)