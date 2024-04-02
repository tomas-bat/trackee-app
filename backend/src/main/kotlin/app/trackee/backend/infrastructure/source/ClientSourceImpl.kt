package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.ClientException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.ClientSource
import app.trackee.backend.domain.model.client.NewClient
import app.trackee.backend.infrastructure.model.client.FirestoreClient
import app.trackee.backend.infrastructure.model.client.toFirestore
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.project.FirestoreProject
import com.google.firebase.cloud.FirestoreClient as GoogleFirestoreClient

internal class ClientSourceImpl : ClientSource {

    private val db = GoogleFirestoreClient.getFirestore()

    override suspend fun readClientById(id: String): FirestoreClient {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(id)
            .get()
            .await()

        return snapshot.toObject(FirestoreClient::class.java)
            ?: throw ClientException.ClientNotFound(id)
    }

    override suspend fun readProjectsForClient(clientId: String): List<FirestoreProject> {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(clientId)
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .get()
            .await()

        return snapshot.documents.map { document ->
            document.toObject(FirestoreProject::class.java)
        }
    }

    override suspend fun readProjectById(clientId: String, projectId: String): FirestoreProject {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(clientId)
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(projectId)
            .get()
            .await()

        return snapshot.toObject(FirestoreProject::class.java)
            ?: throw ClientException.ProjectNotFound(clientId, projectId)
    }

    override suspend fun updateClient(client: FirestoreClient) {
        val ref = db
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(client.id)

        if (!ref.get().await().exists()) {
            throw ClientException.ClientNotFound(client.id)
        }

        val snapshot = ref.get().await()

        if (ref.id != snapshot.id) {
            throw ClientException.ClientIdMismatch(ref.id, snapshot.id)
        }

        if (snapshot.id != client.id) {
            throw ClientException.ClientIdMismatch(snapshot.id, client.id)
        }

        ref.set(client).await()
    }

    override suspend fun deleteClient(clientId: String) {
        // Delete user references
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .listDocuments()
            .map { userDocRef ->
                userDocRef
                    .collection(SourceConstants.Firestore.Collection.CLIENTS)
                    .listDocuments()
                    .filter { it.id == clientId }
            }
            .flatten()
            .forEach { userClient ->
                print("[DEBUG] Delete ${userClient.path}")
//                userClient
//                    .delete()
//                    .await()
            }

        // Delete projects of this client
        db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .listDocuments()
            .filter { it.id == clientId }
            .forEach { projectClient ->
                print("[DEBUG] Delete ${projectClient.path}")
//                projectClient
//                    .delete()
//                    .await()
            }

        // Delete entries of projects of this client
        db
            .collection(SourceConstants.Firestore.Collection.ENTRIES)
            .listDocuments()
            .forEach  { entriesUserDocRef ->
                entriesUserDocRef
                    .collection(SourceConstants.Firestore.Collection.ENTRIES)
                    .listDocuments()
                    .filter { entryRef ->
                        entryRef
                            .get()
                            .await()
                            .toObject(FirestoreTimerEntry::class.java)
                            ?.clientId == clientId
                    }
                    .forEach { entryRef ->
                        print("[DEBUG] Delete ${entryRef.path}")
//                        entryRef
//                            .delete()
//                            .await()
                    }
            }

        // Delete this client
        db
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document(clientId)
            .also {
                print("[DEBUG] Delete ${it.path}")
            }
//            .delete()
//            .await()
    }

    override suspend fun createClient(client: NewClient) {
        val ref = db
            .collection(SourceConstants.Firestore.Collection.CLIENTS)
            .document()

        val firestoreClient = client.toFirestore(id = ref.id)
        ref.set(firestoreClient).await()
    }
}