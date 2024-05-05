package app.trackee.backend.domain.model.clockify

data class ClockifyTimeEntry(
    val billable: Boolean,
    val description: String,
    val customAttributes: List<ClockifyCreateCustomAttributeRequest>,
    val customFields: List<ClockifyUpdateCustomFieldRequest>,
    val end: String,
    val projectId: String,
    val start: String,
    val tagIds: List<String>,
    val taskId: String,
    val type: ClockifyTimeEntryType
)
