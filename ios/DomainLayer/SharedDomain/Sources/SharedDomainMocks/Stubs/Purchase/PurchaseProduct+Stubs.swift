//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension PurchaseProduct {
    static var stub: PurchaseProduct {
        PurchaseProduct(
            id: UUID().uuidString,
            subscriptionPeriod: .oneMonth,
            introductoryDiscount: .init(
                subscriptionPeriod: .twoWeeks,
                price: 0,
                localizedPrice: "Free"
            )
        )
    }
}
