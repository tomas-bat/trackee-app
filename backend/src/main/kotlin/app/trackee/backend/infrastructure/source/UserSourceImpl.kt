package app.trackee.backend.infrastructure.source

import app.trackee.backend.common.Page
import app.trackee.backend.config.exceptions.ClientException
import app.trackee.backend.config.exceptions.ProjectException
import app.trackee.backend.config.exceptions.UserException
import app.trackee.backend.config.util.await
import app.trackee.backend.config.util.toTimestamp
import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.entry.NewTimerEntry
import app.trackee.backend.domain.model.entry.TimerEntry
import app.trackee.backend.domain.model.timer.StartTimerBody
import app.trackee.backend.domain.model.timer.TimerStatus
import app.trackee.backend.domain.model.user.User
import app.trackee.backend.infrastructure.model.client.FirestoreUserClient
import app.trackee.backend.infrastructure.model.entry.FirestoreEntryUser
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.entry.toDomain
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

        val userRef = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)

        // Delete integrations
        userRef
            .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
            .listDocuments()
            .forEach { integrationRef ->
                integrationRef.delete().await()
            }

        // Delete user client refs
        userRef
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .listDocuments()
            .forEach { userClientRef ->
                userClientRef.delete().await()
            }

        // Delete user
        userRef.delete().await()

        // Delete user from auth
        auth.deleteUser(uid)
    }

    override suspend fun readEntries(
        uid: String,
        startAfter: Instant?,
        limit: Int?,
        endAt: Instant?
    ): Page<FirestoreTimerEntry> {
        val entriesCollection = db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .orderBy(SourceConstants.Firestore.FieldName.STARTED_AT, Query.Direction.DESCENDING)

        val snapshot = entriesCollection
            .startAfter(startAfter?.toTimestamp() ?: Timestamp.now())
            .endAt(endAt?.toTimestamp() ?: Timestamp.MIN_VALUE)
            .limit(limit ?: Int.MAX_VALUE)
            .get()
            .await()

        val data = snapshot.documents.map { it.toObject(FirestoreTimerEntry::class.java) }

        val remainingCount = entriesCollection
            .startAfter(data.lastOrNull()?.startedAt ?: Timestamp.MIN_VALUE)
            .count()
            .get()
            .await()
            .count

        return Page(
            data = data,
            isLast = remainingCount == 0.toLong()
        )
    }

    override suspend fun readEntry(uid: String, entryId: String): TimerEntry =
        db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .document(entryId)
            .get()
            .await()
            .toObject(FirestoreTimerEntry::class.java)?.toDomain()
                ?: throw UserException.EntryNotFound(uid, entryId)

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
        timerData.clientId?.let { clientId ->
            timerData.projectId?.let { projectId ->
                if (!isProjectAssignedToUser(uid, clientId, projectId)) {
                    throw UserException.ProjectNotAssignedToUser(uid, clientId, projectId)
                }
            }
        }

        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .update(SourceConstants.Firestore.FieldName.TIMER_DATA, timerData)
            .await()
    }

    override suspend fun createEntry(uid: String, entry: NewTimerEntry): TimerEntry {
        if (!isProjectAssignedToUser(uid, entry.clientId, entry.projectId)) {
            throw UserException.ProjectNotAssignedToUser(uid, entry.clientId, entry.projectId)
        }

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

        return docRef.get().await().toObject(FirestoreTimerEntry::class.java)?.toDomain()
            ?: throw UserException.FailedToGetCreatedEntry(uid)
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

    override suspend fun startTimer(uid: String, body: StartTimerBody) {
        body.clientId?.let { clientId ->
            body.projectId?.let { projectId ->
                if (!isProjectAssignedToUser(uid, clientId, projectId)) {
                    throw UserException.ProjectNotAssignedToUser(uid, clientId, projectId)
                }
            }
        }

        val userRef = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)

        val timerData = userRef.get().await().toObject(FirestoreUser::class.java)?.timerData
            ?: throw UserException.UserNotFound(uid)

        userRef.update(
            mapOf(
                SourceConstants.Firestore.FieldName.TIMER_DATA_CLIENT_ID to body.clientId,
                SourceConstants.Firestore.FieldName.TIMER_DATA_PROJECT_ID to body.projectId,
                SourceConstants.Firestore.FieldName.TIMER_DATA_DESCRIPTION to body.description
            )
        ).await()

        if (timerData.status == TimerStatus.Off.rawValue) {
            userRef.update(
                mapOf(
                    SourceConstants.Firestore.FieldName.TIMER_DATA_STARTED_AT to Timestamp.now(),
                    SourceConstants.Firestore.FieldName.TIMER_DATA_STATUS to TimerStatus.Active.rawValue
                )
            ).await()
        }
    }

    override suspend fun stopTimer(uid: String) {
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .update(
                mapOf(
                    SourceConstants.Firestore.FieldName.TIMER_DATA_STATUS to TimerStatus.Off.rawValue,
                    SourceConstants.Firestore.FieldName.TIMER_DATA_STARTED_AT to null
                )
            )
            .await()
    }

    private suspend fun isProjectAssignedToUser(uid: String, clientId: String, projectId: String): Boolean {
        val userClient = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(clientId)
            .get()
            .await()

        if (!userClient.exists()) return false

        return userClient.toObject(FirestoreUserClient::class.java)?.projectIds?.contains(projectId) ?: false
    }
}

