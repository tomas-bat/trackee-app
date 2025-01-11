//
//  Created by Tomáš Batěk on 16.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import KMPSharedDomain

public struct PaywallPackageViewObject: Equatable {
    public let package: PurchasePackage
    public let isEligibleForIntroductoryDiscount: Bool
    
    public init(
        package: PurchasePackage,
        isEligibleForIntroductoryDiscount: Bool
    ) {
        self.package = package
        self.isEligibleForIntroductoryDiscount = isEligibleForIntroductoryDiscount
    }
}

public extension PaywallPackageViewObject {
    static func stub(id: String) -> PaywallPackageViewObject {
        PaywallPackageViewObject(
            package: .stub(id: id),
            isEligibleForIntroductoryDiscount: .random()
        )
    }
}

public extension [PaywallPackageViewObject] {
    static var stub: [PaywallPackageViewObject] {
        (0..<3).map { idx in
            .stub(id: "\(idx)")
        }
    }
}
