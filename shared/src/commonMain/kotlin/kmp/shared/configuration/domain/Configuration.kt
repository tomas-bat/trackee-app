package kmp.shared.configuration.domain

import kmp.shared.common.provider.AppEnvironment

sealed class Configuration(val host: String) {
    object Alpha : Configuration("trackee.tombatek.eu")

    object Beta : Configuration("trackee.tombatek.eu")

    object Production : Configuration("trackee.tombatek.eu")
}

val AppEnvironment.configuration
    get() = when(this) {
        AppEnvironment.Alpha -> Configuration.Alpha
        AppEnvironment.Beta -> Configuration.Beta
        AppEnvironment.Production -> Configuration.Production
    }
