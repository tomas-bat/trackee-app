package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.IntegrationException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.IntegrationSource
import app.trackee.backend.domain.model.integration.Integration
import app.trackee.backend.domain.model.integration.NewIntegration
import app.trackee.backend.infrastructure.model.integration.toFirestore
import app.trackee.backend.infrastructure.model.integration.toIntegration
import com.google.firebase.cloud.FirestoreClient as GoogleFirestoreClient

internal class IntegrationSourceImpl : IntegrationSource {

    private val db = GoogleFirestoreClient.getFirestore()

    override suspend fun createIntegration(uid: String, integration: NewIntegration) {
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
            .add(integration.toFirestore())
            .await()
    }

    override suspend fun readIntegration(uid: String, integrationId: String): Integration {
        val snapshot = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
            .document(integrationId)
            .get()
            .await()

        return snapshot.toIntegration()
    }

    override suspend fun readIntegrations(uid: String): List<Integration> =
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
            .listDocuments()
            .mapNotNull { integrationRef ->
                integrationRef
                    .get()
                    .await()
                    .toIntegration()
            }

    override suspend fun updateIntegration(uid: String, integration: Integration) {
        val ref = db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
            .document(integration.id)

        if (!ref.get().await().exists()) throw IntegrationException.IntegrationNotFound(uid, integration.id)

        ref.set(integration.toFirestore()).await()
    }


    override suspend fun deleteIntegration(uid: String, integrationId: String) {
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .document(uid)
            .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
            .document(integrationId)
            .delete()
            .await()
    }
}