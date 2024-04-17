package app.trackee.backend.presentation.model.entry

import app.trackee.backend.common.Page
import app.trackee.backend.common.PageDto
import app.trackee.backend.domain.model.entry.TimerEntryPreview

internal fun Page<TimerEntryPreview>.toDto() = PageDto(
    data = data.map { it.toDto() },
    isLast = isLast
)