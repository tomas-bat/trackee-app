package app.trackee.backend.infrastructure.source

import app.trackee.backend.config.exceptions.ProjectException
import app.trackee.backend.config.util.await
import app.trackee.backend.data.source.ProjectSource
import app.trackee.backend.domain.model.project.NewProject
import app.trackee.backend.domain.model.project.NewProjectResponse
import app.trackee.backend.infrastructure.model.client.FirestoreUserClient
import app.trackee.backend.infrastructure.model.entry.FirestoreTimerEntry
import app.trackee.backend.infrastructure.model.integration.toIntegration
import app.trackee.backend.infrastructure.model.project.FirestoreClientProject
import app.trackee.backend.infrastructure.model.project.FirestoreIdentifiableProject
import app.trackee.backend.infrastructure.model.project.FirestoreProject
import app.trackee.backend.infrastructure.model.project.toFirestore
import app.trackee.backend.infrastructure.model.user.FirestoreUser
import com.google.cloud.firestore.FieldValue
import com.google.firebase.cloud.FirestoreClient as GoogleFirestoreClient

internal class ProjectSourceImpl : ProjectSource {

    private val db = GoogleFirestoreClient.getFirestore()

    override suspend fun createProject(project: NewProject): NewProjectResponse {
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

        return NewProjectResponse(clientId = project.clientId, projectId = ref.id)
    }

    override suspend fun updateProject(originalClientId: String, project: FirestoreProject) {
        val ref = db
            .collection(SourceConstants.Firestore.Collection.PROJECTS)
            .document(originalClientId)
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

        // Move project to another client, if client ID has changed
        if (originalClientId != project.clientId) {
            // Delete project under old client
            ref.delete().await()

            val clientProjectRef = db
                .collection(SourceConstants.Firestore.Collection.PROJECTS)
                .document(project.clientId)

            if (!clientProjectRef.get().await().exists()) {
                clientProjectRef.set(FirestoreClientProject(clientId = project.clientId)).await()
            }

            // Add project under new client
            clientProjectRef
                .collection(SourceConstants.Firestore.Collection.PROJECTS)
                .document(project.id)
                .set(project)
                .await()

            // Update entries
            db
                .collection(SourceConstants.Firestore.Collection.ENTRIES)
                .listDocuments()
                .forEach { entriesUserRef ->
                    entriesUserRef
                        .collection(SourceConstants.Firestore.Collection.ENTRIES)
                        .listDocuments()
                        .forEach { entryRef ->
                            entryRef.get().await().toObject(FirestoreTimerEntry::class.java)?.let { entry ->
                                if (entry.projectId == project.id && entry.clientId == originalClientId) {
                                    entryRef.update(SourceConstants.Firestore.FieldName.CLIENT_ID, project.clientId)
                                }
                            }
                        }
                }

            // Update users
            db
                .collection(SourceConstants.Firestore.Collection.USERS)
                .listDocuments()
                .forEach { userRef ->
                    val userClientRef = userRef
                        .collection(SourceConstants.Firestore.Collection.CLIENTS)
                        .document(originalClientId)

                    val userClientSnapshot = userClientRef.get().await()

                    if (userClientSnapshot.exists()) {
                        val projectIds = userClientSnapshot.toObject(FirestoreUserClient::class.java)?.projectIds ?: emptyList()

                        if (projectIds.contains(project.id)) {
                            val newUserClientRef = userRef
                                .collection(SourceConstants.Firestore.Collection.CLIENTS)
                                .document(project.clientId)

                            if (!newUserClientRef.get().await().exists()) {
                                newUserClientRef.set(FirestoreUserClient(projectIds = listOf(project.id))).await()
                            } else {
                                newUserClientRef.update(
                                    SourceConstants.Firestore.FieldName.PROJECT_IDS,
                                    FieldValue.arrayUnion(project.id)
                                )
                            }


                            userClientRef.update(
                                SourceConstants.Firestore.FieldName.PROJECT_IDS,
                                FieldValue.arrayRemove(project.id)
                            ).await()
                        }
                    }

                    userRef.get().await().toObject(FirestoreUser::class.java)?.let { user ->
                        if (user.timerData.projectId == project.id && user.timerData.clientId == originalClientId) {
                            userRef.update(SourceConstants.Firestore.FieldName.TIMER_DATA_CLIENT_ID, project.clientId)
                        }
                    }
                }

            // Update integrations
            db
                .collection(SourceConstants.Firestore.Collection.USERS)
                .listDocuments()
                .forEach { userRef ->
                    userRef
                        .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
                        .listDocuments()
                        .forEach { integrationRef ->
                            val integration = integrationRef.get().await().toIntegration()
                            integration.selectedProjects.forEach { identifiableProject ->
                                if (identifiableProject.clientId == originalClientId && identifiableProject.projectId == project.id) {
                                    // Remove old project
                                    integrationRef.update(
                                        SourceConstants.Firestore.FieldName.SELECTED_PROJECTS,
                                        FieldValue.arrayRemove(identifiableProject.toFirestore())
                                    ).await()
                                    // Add updated project
                                    integrationRef.update(
                                        SourceConstants.Firestore.FieldName.SELECTED_PROJECTS,
                                        FieldValue.arrayUnion(FirestoreIdentifiableProject(project.clientId, project.id))
                                    ).await()
                                }
                            }
                        }
                }
        } else {
            ref.set(project).await()
        }
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

        // Delete integrations of this project
        db
            .collection(SourceConstants.Firestore.Collection.USERS)
            .listDocuments()
            .forEach { userRef ->
                userRef
                    .collection(SourceConstants.Firestore.Collection.INTEGRATIONS)
                    .listDocuments()
                    .forEach { integrationRef ->
                        val integration = integrationRef.get().await().toIntegration()
                        integration.selectedProjects.forEach { identifiableProject ->
                            if (identifiableProject.clientId == clientId && identifiableProject.projectId == projectId) {
                                integrationRef.update(
                                    SourceConstants.Firestore.FieldName.SELECTED_PROJECTS,
                                    FieldValue.arrayRemove(identifiableProject.toFirestore())
                                )
                            }
                        }
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