package kmp.shared.feature.timer.infrastructure.model

import kmp.shared.base.paging.Page
import kmp.shared.base.paging.PageDto

internal fun PageDto<TimerEntryPreviewDto>.toDomain() = Page(
    data = data.map { it.toDomain() },
    isLast = isLast
)