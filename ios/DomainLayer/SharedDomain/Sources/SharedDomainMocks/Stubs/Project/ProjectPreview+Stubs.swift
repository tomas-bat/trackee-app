//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension ProjectPreview {
    static func stub(id: String = UUID().uuidString) -> ProjectPreview {
        ProjectPreview(
            id: id,
            client: .stub(),
            type: .work,
            name: "Lorem ipsum project"
        )
    }
}

public extension [ProjectPreview] {
    static var stub: [ProjectPreview] {
        (0..<15).map { id in .stub(id: "\(id)") }
    }
}
