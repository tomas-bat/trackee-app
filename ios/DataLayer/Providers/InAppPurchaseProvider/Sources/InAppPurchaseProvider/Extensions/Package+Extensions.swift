//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import RevenueCat
import KMPSharedDomain

extension Package {
    func toDomain() throws -> PurchasePackage {
        PurchasePackage(
            id: identifier,
            localizedPrice: localizedPriceString,
            offeringId: offeringIdentifier,
            product: try storeProduct.toDomain()
        )
    }
}
