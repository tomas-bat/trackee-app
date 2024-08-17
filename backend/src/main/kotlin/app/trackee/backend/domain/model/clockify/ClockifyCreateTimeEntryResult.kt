package app.trackee.backend.domain.model.clockify

data class ClockifyCreateTimeEntryResult(
    val response: ClockifyCreateTimeEntryResponse,
    val workspaceId: String
)
