package kmp.shared.base.error.util

import io.ktor.client.engine.darwin.*
import kmp.shared.base.ErrorResult
import kmp.shared.base.error.domain.CommonError

internal actual fun handlePlatformError(throwable: Throwable): ErrorResult =
    if (throwable is DarwinHttpRequestException) {
        when (throwable.origin.code) {
            -1004L -> CommonError.ServerNotReachable(throwable)
            -1005L -> CommonError.NoNetworkConnection(throwable)
            -1001L -> CommonError.Timeout(throwable)
            else -> throw throwable
        }
    } else throw throwable