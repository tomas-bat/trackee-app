package app.trackee.backend.infrastructure.model.user

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.timer.toDomain
import kotlinx.serialization.Serializable

@Serializable
internal data class FirestoreUser(
    val uid: String = "",
    val timer_data: FirestoreTimerData = FirestoreTimerData(),
    val client_ids: List<String> = emptyList(),
)

internal fun FirestoreUser.toDomain() = User(
    uid = uid,
    timerData = timer_data.toDomain(),
    clientIds = client_ids
)