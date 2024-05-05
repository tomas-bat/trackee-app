package app.trackee.backend.infrastructure.model.integration

import app.trackee.backend.config.exceptions.IntegrationException
import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration
import com.google.cloud.firestore.DocumentSnapshot
import com.google.cloud.firestore.annotation.PropertyName

data class FirestoreCsvIntegration(
    val type: String = "csv",
    val label: String = ""
)

data class FirestoreClockifyIntegration(
    val type: String = "clockify",
    val label: String = "",

    @get:PropertyName("auto_export")
    @set:PropertyName("auto_export")
    var autoExport: Boolean = false,

    @get:PropertyName("workspace_name")
    @set:PropertyName("workspace_name")
    var workspaceName: String? = null,

    @get:PropertyName("api_key")
    @set:PropertyName("api_key")
    var apiKey: String? = null
)

internal fun Integration.Csv.toFirestore() = FirestoreCsvIntegration(
    label = label
)

internal fun Integration.Clockify.toFirestore() = FirestoreClockifyIntegration(
    label = label,
    autoExport = autoExport,
    apiKey = apiKey,
    workspaceName = workspaceName
)

internal fun DocumentSnapshot.toIntegration(): Integration {
    val type = this.data?.get("type") as? String
        ?: throw IntegrationException.UnableToParseIntegration(null, null)

    return when (type) {
        "csv" -> this.toObject(FirestoreCsvIntegration::class.java)?.toDomain(id = this.id)
        "clockify" -> this.toObject(FirestoreClockifyIntegration::class.java)?.toDomain(id = this.id)
        else -> null
    } ?: throw IntegrationException.UnableToParseIntegration(null, null)
}

internal fun FirestoreCsvIntegration.toDomain(id: String) = Integration.Csv(
    id = id,
    label = label
)

internal fun FirestoreClockifyIntegration.toDomain(id: String) = Integration.Clockify(
    id = id,
    label = label,
    autoExport = autoExport,
    apiKey = apiKey,
    workspaceName = workspaceName
)

internal fun NewIntegration.Csv.toFirestore() = FirestoreCsvIntegration(
    label = label
)

internal fun NewIntegration.Clockify.toFirestore() = FirestoreClockifyIntegration(
    label = label,
    autoExport = autoExport,
    apiKey = apiKey,
    workspaceName = workspaceName
)

internal fun Integration.toFirestore() = when (this) {
    is Integration.Csv -> this.toFirestore()
    is Integration.Clockify -> this.toFirestore()
}

internal fun NewIntegration.toFirestore() = when(this) {
    is NewIntegration.Csv -> this.toFirestore()
    is NewIntegration.Clockify -> this.toFirestore()
}