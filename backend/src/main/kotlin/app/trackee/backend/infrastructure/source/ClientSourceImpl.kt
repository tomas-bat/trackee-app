package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.ClientException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.ClientSource
import app.trackee.backend.infrastructure.model.client.FirestoreClient
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
}