package kmp.shared.feature.purchase.domain.model

data class PurchaseProduct(
    val id: String,
    val subscriptionPeriod: PurchaseSubscriptionPeriod?,
    val introductoryDiscount: PurchaseIntroductoryDiscount?
)