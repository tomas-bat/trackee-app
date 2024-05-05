package app.trackee.backend.domain.model.clockify

data class ClockifyUpdateCustomFieldRequest(
    val customFieldId: String,
    val sourceType: String?,
    val value: Any?
)
