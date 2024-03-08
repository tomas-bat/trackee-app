package app.trackee.backend.config.firebase

import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import org.koin.dsl.module

internal val firebaseModule = module {
    val app = FirebaseApp.initializeApp()
    single { FirebaseAuth.getInstance(app) }
}