package app.trackee.backend.infrastructure.source

import app.trackee.backend.data.source.UserSource
import app.trackee.backend.domain.model.user.User
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import com.google.firebase.database.FirebaseDatabase
import com.google.firestore.*

class UserSourceImpl : UserSource {
    override suspend fun readUserByUid(uid: String): User {
        TODO("not yet implemented")
//        val db = FirestoreClient.getFirestore()
//
//        db.collection("users").ge
    }
}