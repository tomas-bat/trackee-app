package kmp.shared.common.provider

enum class AppEnvironment {
    Alpha, Beta, Production
}

enum class AppFlavor {
    Debug, Release
}

interface AppInfoProvider {
    val environment: AppEnvironment
    val flavor: AppFlavor

    suspend fun logout()
}