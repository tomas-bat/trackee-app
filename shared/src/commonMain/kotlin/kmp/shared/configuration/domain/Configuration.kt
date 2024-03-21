package kmp.shared.configuration.domain

sealed class Configuration(val host: String) {
    object Alpha : Configuration("api-alpha.trackee.app")

    object Beta : Configuration("api-alpha.trackee.app")

    object Production : Configuration("api.trackee.app")
}