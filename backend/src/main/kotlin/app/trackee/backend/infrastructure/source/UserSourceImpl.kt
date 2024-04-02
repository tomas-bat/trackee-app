package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.client.FirestoreUserClient
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.entry.toFirestoreEntry
import app.trackee.backend.infrastructure.model.project.IdentifiableProject
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import app.trackee.backend.infrastructure.model.user.toFirestore
import com.google.firebase.cloud.FirestoreClient

internal class UserSourceImpl : UserSource {

    private val db = FirestoreClient.getFirestore()

    override suspend fun readUserByUid(uid: String): FirestoreUser {
        val documentSnapshot = db.collection(SourceConstants.Firestore.Collection.USERS).document(uid).get().await()

        return documentSnapshot.toObject(FirestoreUser::class.java)
            ?: throw UserException.UserNotFound(uid = uid)
    }

    override suspend fun readEntries(uid: String): List<FirestoreTimerEntry> {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .orderBy(SourceConstants.Firestore.FieldName.STARTED_AT)
            .get()
            .await()


        return snapshot.documents.map { document ->
            document.toObject(FirestoreTimerEntry::class.java)
        }
    }

    override suspend fun readProjectIds(uid: String): List<IdentifiableProject> =
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .get()
            .await()
            .map { snapshot ->
                snapshot.toObject(FirestoreUserClient::class.java).projectIds.map { projectId ->
                    IdentifiableProject(snapshot.id, projectId)
                }
            }
            .flatten()

    override suspend fun createUser(user: User): FirestoreUser {
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(user.uid)
            .set(user.toFirestore())
            .await()

        return db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(user.uid)
            .get()
            .await()
            .toObject(FirestoreUser::class.java) ?: throw UserException.UserNotFound(user.uid)
    }

    override suspend fun updateTimer(uid: String, timerData: FirestoreTimerData) {
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .update(SourceConstants.Firestore.FieldName.TIMER_DATA, timerData)
            .await()
    }

    override suspend fun createEntry(uid: String, entry: NewTimerEntry) {
        val docRef = db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document()

        val firestoreEntry = entry.toFirestoreEntry(id = docRef.id)
        docRef.set(firestoreEntry).await()
    }

    override suspend fun deleteEntry(uid: String, entryId: String) {
        db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(entryId)
            .delete()
            .await()
    }
}

