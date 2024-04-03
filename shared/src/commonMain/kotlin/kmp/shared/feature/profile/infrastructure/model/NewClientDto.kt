package kmp.shared.feature.profile.infrastructure.model

import kmp.shared.feature.profile.domain.model.NewClient
import kotlinx.serialization.Serializable

@Serializable
internal data class NewClientDto(
    val name: String
)

internal fun NewClient.toDto() = NewClientDto(
    name = name
)