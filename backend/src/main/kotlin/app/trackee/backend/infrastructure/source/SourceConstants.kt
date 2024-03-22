package app.trackee.backend.infrastructure.source

internal class SourceConstants {
    internal class Firestore {
        internal class Collection {
            companion object {
                const val users = "users"
                const val entries = "entries"
                const val clients = "clients"
                const val projects = "projects"
            }
        }
    }
}