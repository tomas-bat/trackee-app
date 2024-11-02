package kmp.shared.base.error.domain

import kmp.shared.base.ErrorResult

sealed class PurchaseError(
    message: String? = null,
    throwable: Throwable? = null,
) : ErrorResult(message, throwable) {

    data object NoProducts : PurchaseError()
    data object InvalidSubscriptionPeriod : PurchaseError()
}