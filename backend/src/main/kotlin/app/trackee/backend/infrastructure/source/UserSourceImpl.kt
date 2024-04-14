package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.ClientException
import app.trackee.backend.config.exceptions.ProjectException
import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.config.util.await
import app.trackee.backend.config.util.toTimestamp
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.timer.TimerStatus
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.client.FirestoreUserClient
import app.trackee.backend.infrastructure.model.entry.FirestoreEntryUser
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.entry.toFirestoreEntry
import app.trackee.backend.infrastructure.model.project.IdentifiableProject
import app.trackee.backend.infrastructure.model.timer.FirestoreTimerData
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import app.trackee.backend.infrastructure.model.user.toFirestore
import com.google.cloud.Timestamp
import com.google.cloud.firestore.FieldValue
import com.google.cloud.firestore.Query
import com.google.firebase.auth.FirebaseAuth
import kotlinx.datetime.Instant
import com.google.firebase.cloud.FirestoreClient as GoogleFirestoreClient


internal class UserSourceImpl : UserSource {

    private val db = GoogleFirestoreClient.getFirestore()
    private val auth = FirebaseAuth.getInstance()

    override suspend fun readUserByUid(uid: String): FirestoreUser {
        val documentSnapshot = db.collection(SourceConstants.Firestore.Collection.USERS).document(uid).get().await()

        return documentSnapshot.toObject(FirestoreUser::class.java)
            ?: throw UserException.UserNotFound(uid = uid)
    }

    override suspend fun deleteUser(uid: String) {
        // Delete user's entries
        val userEntriesRef = db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)

        userEntriesRef
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .listDocuments()
            .forEach { entryRef ->
                entryRef.delete().await()
            }

        userEntriesRef.delete().await()

        // Delete user
        val userRef = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)

        userRef
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .listDocuments()
            .forEach { userClientRef ->
                userClientRef.delete().await()
            }

        userRef.delete().await()

        auth.deleteUser(uid)
    }

    override suspend fun readEntries(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): List<FirestoreTimerEntry> {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .orderBy(SourceConstants.Firestore.FieldName.STARTED_AT, Query.Direction.DESCENDING)
            .startAfter(startAfter?.toTimestamp() ?: Timestamp.now())
            .endAt(endAt?.toTimestamp() ?: Timestamp.MIN_VALUE)
            .limit(limit ?: Int.MAX_VALUE)
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
        val entryUserRef = db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)

        if (!entryUserRef.get().await().exists()) {
            entryUserRef.set(FirestoreEntryUser(uid = uid))
        }

        val docRef = entryUserRef
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

    override suspend fun readClientIds(uid: String): List<String> =
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .get()
            .await()
            .map { it.id }

    override suspend fun assignClientToUser(uid: String, clientId: String) {
        val exists = db
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(clientId)
            .get()
            .await()
            .exists()

        if (!exists) throw ClientException.ClientNotFound(clientId)

        val ref = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(clientId)

        if (!ref.get().await().exists()) {
            ref.set(FirestoreUserClient()).await()
        }
    }

    override suspend fun assignProjectToUser(uid: String, clientId: String, projectId: String) {
        val exists = db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(clientId)
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(projectId)
            .get()
            .await()
            .exists()

        if (!exists) throw ProjectException.ProjectNotFound(clientId, projectId)

        val ref = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(clientId)


        if (!ref.get().await().exists()) {
            ref.set(FirestoreUserClient()).await()
        }

        ref.update(
            SourceConstants.Firestore.FieldName.PROJECT_IDS,
            FieldValue.arrayUnion(projectId)
        )
    }

    override suspend fun startTimer(uid: String) {
        val userRef = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)

        val timerData = userRef.get().await().toObject(FirestoreUser::class.java)?.timerData
            ?: throw UserException.UserNotFound(uid)

        if (timerData.status == TimerStatus.Off.rawValue) {
            userRef.update(
                mapOf(
                    SourceConstants.Firestore.FieldName.TIMER_DATA_STARTED_AT to Timestamp.now(),
                    SourceConstants.Firestore.FieldName.TIMER_DATA_STATUS to TimerStatus.Active.rawValue
                )
            ).await()
        }
    }
}

