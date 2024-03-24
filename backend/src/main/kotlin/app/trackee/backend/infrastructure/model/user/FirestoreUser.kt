package app.trackee.backend.infrastructure.model.user

import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.timer.toDomain
import com.google.cloud.firestore.annotation.PropertyName

internal data class FirestoreUser(
    val uid: String = "",

    @get:PropertyName("timer_data")
    @set:PropertyName("timer_data")
    var timerData: FirestoreTimerData = FirestoreTimerData(),
)

internal fun FirestoreUser.toDomain() = User(
    uid = uid,
    timerData = timerData.toDomain()
)