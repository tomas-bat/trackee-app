package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.ProjectException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.ProjectSource
import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.project.FirestoreClientProject
import app.trackee.backend.infrastructure.model.project.FirestoreProject
import app.trackee.backend.infrastructure.model.project.toFirestore
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import com.google.cloud.firestore.FieldValue
import com.google.firebase.cloud.FirestoreClient as GoogleFirestoreClient

internal class ProjectSourceImpl : ProjectSource {

    private val db = GoogleFirestoreClient.getFirestore()

    override suspend fun createProject(project: NewProject) {
        val clientProjectRef = db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(project.clientId)

        if (!clientProjectRef.get().await().exists()) {
            clientProjectRef
                .set(FirestoreClientProject(clientId = project.clientId))
                .await()
        }

        val ref = clientProjectRef
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document()

        val firestoreProject = project.toFirestore(id = ref.id)
        ref.set(firestoreProject).await()
    }

    override suspend fun updateProject(project: FirestoreProject) {
        val ref = db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(project.clientId)
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(project.id)

        if (!ref.get().await().exists()) {
            throw ProjectException.ProjectNotFound(project.clientId, project.id)
        }

        val snapshot = ref.get().await()

        if (ref.id != snapshot.id) {
            throw ProjectException.ProjectIdMismatch(ref.id, snapshot.id)
        }

        if (snapshot.id != project.id) {
            throw ProjectException.ProjectIdMismatch(snapshot.id, project.id)
        }

        ref.set(project).await()
    }

    override suspend fun deleteProject(clientId: String, projectId: String) {
        // Delete user references
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .listDocuments()
            .forEach { userDocRef ->
                userDocRef
                    .collection(SourceConstants.Firestore.Collection.CLIENTS)
                    .listDocuments()
                    .forEach { userClientRef ->
                        userClientRef.update(
                            SourceConstants.Firestore.FieldName.PROJECT_IDS,
                            FieldValue.arrayRemove(projectId)
                        )
                    }

                if (userDocRef.get().await().toObject(FirestoreUser::class.java)?.timerData?.projectId == projectId) {
                    userDocRef.update(
                        SourceConstants.Firestore.FieldName.TIMER_DATA_CLIENT_ID,
                        null
                    )
                    userDocRef.update(
                        SourceConstants.Firestore.FieldName.TIMER_DATA_PROJECT_ID,
                        null
                    )
                }
            }

        // Delete entries of this project
        db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .listDocuments()
            .forEach { entriesUserDocRef ->
                entriesUserDocRef
                    .collection(SourceConstants.Firestore.Collection.ENTRIES)
                    .listDocuments()
                    .filter { entryRef ->
                        entryRef
                            .get()
                            .await()
                            .toObject(FirestoreTimerEntry::class.java)
                            ?.projectId == projectId
                    }
                    .forEach { entryRef ->
                        entryRef
                            .delete()
                            .await()
                    }
            }

        // Delete this project
        db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(clientId)
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(projectId)
            .delete()
            .await()
    }
}