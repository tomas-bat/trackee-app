package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import com.google.firebase.cloud.FirestoreClient

internal class UserSourceImpl : UserSource {
    override suspend fun readUserByUid(uid: String): FirestoreUser {
        val db = FirestoreClient.getFirestore()
        val documentSnapshot = db.collection(SourceConstants.Firestore.Collection.users).document(uid).get().await()

        return documentSnapshot.toObject<FirestoreUser>(FirestoreUser::class.java)
            ?: throw UserException.UserNotFound(uid = uid)
    }
}