package app.trackee.backend.infrastructure.model.clockify

import app.trackee.backend.domain.model.clockify.ClockifyTimeEntry
import app.trackee.backend.domain.model.clockify.ClockifyTimeEntryType
import kotlinx.serialization.Serializable

@Serializable
data class RawClockifyTimeEntry(
    val id: String,
    val billable: Boolean,
    val description: String,
    val customAttributes: List<RawClockifyCreateCustomAttributeRequest>,
    val customFields: List<RawClockifyUpdateCustomFieldRequest>,
    val end: String,
    val projectId: String,
    val start: String,
    val tagIds: List<String>,
    val taskId: String,
    val type: String
)

internal fun ClockifyTimeEntry.toRaw() = RawClockifyTimeEntry(
    id = id,
    billable = billable,
    description = description,
    customAttributes = customAttributes.map { it.toRaw() },
    customFields = customFields.map { it.toRaw() },
    end = end,
    projectId = projectId,
    start = start,
    tagIds = tagIds,
    taskId = taskId,
    type = type.rawValue
)

internal fun RawClockifyTimeEntry.toDomain() = ClockifyTimeEntry(
    id = id,
    billable = billable,
    description = description,
    customAttributes = customAttributes.map { it.toDomain() },
    customFields = customFields.map { it.toDomain() },
    end = end,
    projectId = projectId,
    start = start,
    tagIds = tagIds,
    taskId = taskId,
    type = ClockifyTimeEntryType.entries.first { it.rawValue == type }
)