package app.trackee.backend.presentation.model.entry

import app.trackee.backend.common.Page
import app.trackee.backend.common.PageDto
import app.trackee.backend.domain.model.entry.TimerEntry

internal fun Page<TimerEntry>.toDto() = PageDto(
    data = data.map { it.toDto() },
    isLast = isLast
)