package kmp.shared.base.error.infrastructure

import kotlinx.serialization.Serializable

@Serializable
data class ErrorDto(
    val type: String,
    val message: String? = null,
    val params: Map<String, String> = emptyMap(),
    val debugMessage: String? = null
)
