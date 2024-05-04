package kmp.shared.feature.integration.domain.model

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