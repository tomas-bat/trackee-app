package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import com.google.firebase.cloud.FirestoreClient

internal class UserSourceImpl : UserSource {

    private val db = FirestoreClient.getFirestore()

    override suspend fun readUserByUid(uid: String): FirestoreUser {
        val documentSnapshot = db.collection(SourceConstants.Firestore.Collection.users).document(uid).get().await()

        return documentSnapshot.toObject(FirestoreUser::class.java)
            ?: throw UserException.UserNotFound(uid = uid)
    }

    override suspend fun readEntries(uid: String): List<FirestoreTimerEntry> {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.entries)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.entries)
            .get()
            .await()


        return snapshot.documents.map { document ->
            document.toObject(FirestoreTimerEntry::class.java)
        }
    }
}