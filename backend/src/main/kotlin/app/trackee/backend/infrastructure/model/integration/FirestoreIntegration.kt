package app.trackee.backend.infrastructure.model.integration

import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.IntegrationType
import app.trackee.backend.domain.model.integration.NewIntegration
import com.google.cloud.firestore.annotation.PropertyName

internal data class FirestoreIntegration(
    val label: String = "",
    val type: String = "",

    @get:PropertyName("api_key")
    @set:PropertyName("api_key")
    var apiKey: String? = null
)

internal fun FirestoreIntegration.toDomain(id: String) = Integration(
    id = id,
    label = label,
    type = IntegrationType.entries.first { it.rawValue == type },
    apiKey = apiKey
)

internal fun Integration.toFirestore() = FirestoreIntegration(
    label = label,
    type = type.rawValue,
    apiKey = apiKey
)

internal fun NewIntegration.toFirestore() = FirestoreIntegration(
    label = label,
    type = type.rawValue,
    apiKey = apiKey
)