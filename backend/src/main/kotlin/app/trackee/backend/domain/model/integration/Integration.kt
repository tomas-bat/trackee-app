package app.trackee.backend.domain.model.integration

sealed class Integration {
    abstract val id: String
    abstract val label: String

    data class Csv(
        override val id: String,
        override val label: String
    ) : Integration()

    data class Clockify(
        override val id: String,
        override val label: String,
        val apiKey: String?,
        val workspaceName: String?,
        val autoExport: Boolean
    ) : Integration()
}