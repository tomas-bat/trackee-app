package kmp.shared.configuration.domain

import kmp.shared.common.provider.AppEnvironment

sealed class Configuration(val host: String) {
    object Alpha : Configuration("api.trackee.app")

    object Beta : Configuration("api.trackee.app")

    object Production : Configuration("api.trackee.app")
}

val AppEnvironment.configuration
    get() = when(this) {
        AppEnvironment.Alpha -> Configuration.Alpha
        AppEnvironment.Beta -> Configuration.Beta
        AppEnvironment.Production -> Configuration.Production
    }
