//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain

public extension PurchaseSubscriptionPeriod {
    func localized(for localizedPrice: String) -> String {
        switch self {
        case .twoWeeks: "\(localizedPrice) \(L10n.paywall_every_two_weeks)"
        case .oneMonth: "\(localizedPrice) \(L10n.paywall_monthly)"
        case .oneYear: "\(localizedPrice) \(L10n.paywall_annually)"
        }
    }
}
