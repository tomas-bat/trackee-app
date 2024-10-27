package kmp.shared.di

import io.ktor.client.engine.darwin.*
import kmp.shared.common.provider.AppInfoProvider
import kmp.shared.common.provider.AppleSignInProvider
import kmp.shared.common.provider.AuthProvider
import kmp.shared.common.provider.InAppPurchaseProvider
import kmp.shared.system.Config
import kmp.shared.system.ConfigImpl
import kmp.shared.system.Log
import kmp.shared.system.Logger
import kotlinx.cinterop.ObjCClass
import kotlinx.cinterop.ObjCProtocol
import kotlinx.cinterop.getOriginalKotlinClass
import org.koin.core.Koin
import org.koin.core.parameter.parametersOf
import org.koin.core.qualifier.Qualifier
import org.koin.dsl.module

fun initKoinIos(
    doOnStartup: () -> Unit,
    appleSignInProvider: AppleSignInProvider,
    authProvider: AuthProvider,
    appInfoProvider: AppInfoProvider,
    inAppPurchaseProvider: InAppPurchaseProvider
) = initKoin {
    modules(
        module {
            single { doOnStartup }
            single { appleSignInProvider }
            single { authProvider }
            single { appInfoProvider }
            single { inAppPurchaseProvider }
        },
    )
}

actual val platformModule = module {
    single<Config> { ConfigImpl() }
    single<Logger> { Log }
    single { Darwin.create() }
}

fun Koin.get(objCProtocol: ObjCProtocol): Any {
    val kClazz = getOriginalKotlinClass(objCProtocol)!!
    return get(kClazz, null)
}

fun Koin.get(objCClass: ObjCClass): Any {
    val kClazz = getOriginalKotlinClass(objCClass)!!
    return get(kClazz, null)
}

fun Koin.get(objCClass: ObjCClass, qualifier: Qualifier?, parameter: Any): Any {
    val kClazz = getOriginalKotlinClass(objCClass)!!
    return get(kClazz, qualifier) { parametersOf(parameter) }
}

fun Koin.get(objCClass: ObjCClass, parameter: Any): Any {
    val kClazz = getOriginalKotlinClass(objCClass)!!
    return get(kClazz, null) { parametersOf(parameter) }
}

fun Koin.get(objCClass: ObjCClass, qualifier: Qualifier?): Any {
    val kClazz = getOriginalKotlinClass(objCClass)!!
    return get(kClazz, qualifier, null)
}
