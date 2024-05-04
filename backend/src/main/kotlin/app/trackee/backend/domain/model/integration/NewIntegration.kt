package app.trackee.backend.domain.model.integration

sealed class NewIntegration {
    abstract val label: String

    data class Csv(
        override val label: String
    ) : NewIntegration()

    data class Clockify(
        override val label: String,
        val apiKey: String?,
        val autoExport: Boolean
    ) : NewIntegration()
}
