package kmp.shared.feature.purchase.domain.model

data class PurchaseIntroductoryDiscount(
    val subscriptionPeriod: PurchaseSubscriptionPeriod?,
    val price: Double,
    val localizedPrice: String
)
