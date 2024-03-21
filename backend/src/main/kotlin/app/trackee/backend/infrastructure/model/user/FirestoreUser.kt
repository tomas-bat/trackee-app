package app.trackee.backend.infrastructure.model.user

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.entry.toDomain
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.timer.toDomain
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreUser(
    val uid: String = "",
    val timer: FirestoreTimerData = FirestoreTimerData(),
    val entries: List<FirestoreTimerEntry> = emptyList(),
    val clientIds: List<String> = emptyList(),
)

internal fun FirestoreUser.toDomain(uid: String) = User(
    uid = uid,
    timer = timer.toDomain(),
    entries = entries.map { it.toDomain() },
    clientIds = clientIds
)