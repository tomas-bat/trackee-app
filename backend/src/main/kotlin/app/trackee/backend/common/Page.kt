package app.trackee.backend.common

import kotlinx.serialization.Serializable

data class Page<T>(
    val data: List<T>,
    val isLast: Boolean
)

@Serializable
data class PageDto<T>(
    val data: List<T>,
    val isLast: Boolean
)