package app.trackee.backend.domain.model.clockify

data class ClockifyCreateCustomAttributeRequest(
    val name: String,
    val namespace: String,
    val value: String
)
