package kmp.shared.di

import kmp.shared.feature.auth.authModule
import kmp.shared.feature.integration.integrationModule
import kmp.shared.feature.intent.intentModule
import kmp.shared.feature.profile.profileModule
import kmp.shared.feature.timer.timerModule
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
    profileModule,
    intentModule,
    integrationModule
)

private val commonModule = module {
    single {
        NetworkClient.Ktor.getClient(
            get(),
            get()
        )
    }

}

expect val platformModule: Module
