package app.trackee.backend.domain.model.integration

enum class IntegrationType(val rawValue: String) {
    Clockify("clockify"),
    CSV("csv")
}