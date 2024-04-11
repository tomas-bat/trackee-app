package kmp.shared.configuration.domain

sealed class Configuration(val host: String) {
    object Alpha : Configuration("trackee-app-production.up.railway.app")

    object Beta : Configuration("trackee-app-production.up.railway.app")

    object Production : Configuration("trackee-app-production.up.railway.app")
}