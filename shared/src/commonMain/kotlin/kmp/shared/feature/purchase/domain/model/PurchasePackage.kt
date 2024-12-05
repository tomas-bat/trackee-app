package kmp.shared.feature.purchase.domain.model

data class PurchasePackage(
    val id: String,
    val localizedPrice: String,
    val offeringId: String,
    val product: PurchaseProduct
)