//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import RevenueCat
import KMPSharedDomain

extension StoreProductDiscount {
    func toDomain() throws -> PurchaseIntroductoryDiscount {
        PurchaseIntroductoryDiscount(
            subscriptionPeriod: try subscriptionPeriod.toDomain(),
            price: Double(truncating: priceDecimalNumber),
            localizedPrice: localizedPriceString
        )
    }
}

