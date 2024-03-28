package app.trackee.backend.infrastructure.source

internal class SourceConstants {
    internal class Firestore {
        internal class Collection {
            companion object {
                const val USERS = "users"
                const val ENTRIES = "entries"
                const val CLIENTS = "clients"
                const val PROJECTS = "projects"
            }
        }

        internal class FieldName {
            companion object {
                const val TIMER_DATA = "timer_data"
            }
        }
    }
}