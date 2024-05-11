//
//  Created by Tomáš Batěk on 11.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension IdentifiableProject {
    static func stub(id: String = UUID().uuidString) -> IdentifiableProject {
        IdentifiableProject(
            projectId: id,
            clientId: "client_\(id)"
        )
    }
}

public extension [IdentifiableProject] {
    static var stub: [IdentifiableProject] {
        (0..<10).map { id in .stub(id: "\(id)") }
    }
}
