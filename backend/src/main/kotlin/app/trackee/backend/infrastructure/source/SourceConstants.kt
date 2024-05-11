package app.trackee.backend.infrastructure.source

internal class SourceConstants {
    internal class Firestore {
        internal class Collection {
            companion object {
                const val USERS = "users"
                const val ENTRIES = "entries"
                const val CLIENTS = "clients"
                const val PROJECTS = "projects"
                const val INTEGRATIONS = "integrations"
            }
        }

        internal class FieldName {
            companion object {
                const val TIMER_DATA = "timer_data"
                const val STARTED_AT = "started_at"
                const val PROJECT_IDS = "project_ids"
                const val TIMER_DATA_PROJECT_ID = "timer_data.project_id"
                const val TIMER_DATA_CLIENT_ID = "timer_data.client_id"
                const val TIMER_DATA_STATUS = "timer_data.status"
                const val TIMER_DATA_STARTED_AT = "timer_data.started_at"
                const val TIMER_DATA_DESCRIPTION = "timer_data.description"
                const val CLIENT_ID = "client_id"
                const val SELECTED_PROJECTS = "selected_projects"
            }
        }
    }
}