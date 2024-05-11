//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension Integration {
    static func stub(id: String = UUID().uuidString) -> Integration {
        Integration.Csv(
            id: id,
            label: "Lorem ipsum",
            selectedProjects: .stub
        )
    }
}

public extension [Integration] {
    static var stub: [Integration] {
        (0..<5).map { idx in .stub(id: "\(idx)") }
    }
}
