package app.trackee.backend.infrastructure.model.project

import com.google.cloud.firestore.annotation.PropertyName

internal data class FirestoreClientProject(
    @get:PropertyName("client_id")
    @set:PropertyName("client_id")
    var clientId: String = ""
)