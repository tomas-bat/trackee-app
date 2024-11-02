//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import RevenueCat
import KMPSharedDomain
import SharedDomain

extension SubscriptionPeriod {
    func toDomain() throws -> PurchaseSubscriptionPeriod {
        switch (value, unit) {
        case (2, .week): .twoWeeks
        case (1, .month): .oneMonth
        case (1, .year): .oneYear
        default: throw KMPError(PurchaseError.InvalidSubscriptionPeriod())
        }
    }
}
