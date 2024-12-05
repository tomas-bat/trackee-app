//
//  Created by Tomáš Batěk on 01.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension PurchasePackage {
    static func stub(id: String) -> PurchasePackage {
        PurchasePackage(
            id: id,
            localizedPrice: "\(Int.random(in: 1...50)) Kč",
            offeringId: "offering_\(id)",
            product: .stub
        )
    }
    
    static var stub: PurchasePackage {
        stub(id: UUID().uuidString)
    }
}

public extension [PurchasePackage] {
    static var stub: [PurchasePackage] {
        (0..<3).map { idx in
            PurchasePackage.stub(id: "\(idx)")
        }
    }
}
