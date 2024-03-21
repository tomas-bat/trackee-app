package kmp.shared.di

import kmp.shared.configuration.domain.Configuration
import kmp.shared.feature.auth.authModule
import kmp.shared.feature.timer.timerModule
import kmp.shared.feature.user.userModule
import kmp.shared.network.NetworkClient
import org.koin.core.KoinApplication
import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.dsl.KoinAppDeclaration
import org.koin.dsl.module

fun initKoin(appDeclaration: KoinAppDeclaration = {}): KoinApplication {
    val koinApplication = startKoin {
        appDeclaration()
        modules(commonModule, platformModule)
        modules(sharedModules)
    }

    // Dummy initialization logic, making use of appModule declarations for demonstration purposes.
    val koin = koinApplication.koin
    val doOnStartup =
        koin.getOrNull<() -> Unit>() // doOnStartup is a lambda which is implemented in Swift on iOS side
    doOnStartup?.invoke()

    return koinApplication
}

private val sharedModules = listOf(
    authModule,
    timerModule,
    userModule
)

private val commonModule = module {
    single {
        NetworkClient.Ktor.getClient(Configuration.Alpha, get())
    }

}

expect val platformModule: Module
