
//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import RevenueCat
import KMPSharedDomain

extension StoreProduct {
    func toDomain() throws -> PurchaseProduct {
        PurchaseProduct(
            id: productIdentifier,
            subscriptionPeriod: try subscriptionPeriod?.toDomain(),
            introductoryDiscount: try introductoryDiscount?.toDomain()
        )
    }
}
