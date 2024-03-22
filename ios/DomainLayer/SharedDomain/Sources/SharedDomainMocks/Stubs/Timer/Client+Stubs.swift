//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension Client {
    static func stub(id: String = UUID().uuidString) -> Client {
        Client(
            id: id,
            name: "Sit amet"
        )
    }
}
