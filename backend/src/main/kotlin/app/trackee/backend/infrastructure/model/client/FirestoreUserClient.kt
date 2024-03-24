package app.trackee.backend.infrastructure.model.client

import com.google.cloud.firestore.annotation.PropertyName

internal data class FirestoreUserClient(
    @get:PropertyName("project_ids")
    @set:PropertyName("project_ids")
    var projectIds: List<String> = emptyList()
)