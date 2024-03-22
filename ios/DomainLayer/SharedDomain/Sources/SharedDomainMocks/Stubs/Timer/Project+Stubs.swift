//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension Project {
    static func stub(id: String = UUID().uuidString) -> Project {
        Project(
            id: id,
            clientId: "client_\(id)",
            type: .work,
            name: "Lorem ipsum project"
        )
    }
}
