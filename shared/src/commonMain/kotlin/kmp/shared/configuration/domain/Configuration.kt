package kmp.shared.configuration.domain

import kmp.shared.common.provider.AppEnvironment

sealed class Configuration(val host: String) {
    object Alpha : Configuration("trackee-app-production.up.railway.app")

    object Beta : Configuration("trackee-app-production.up.railway.app")

    object Production : Configuration("trackee-app-production.up.railway.app")
}

val AppEnvironment.configuration
    get() = when(this) {
        AppEnvironment.Alpha -> Configuration.Alpha
        AppEnvironment.Beta -> Configuration.Beta
        AppEnvironment.Production -> Configuration.Production
    }
