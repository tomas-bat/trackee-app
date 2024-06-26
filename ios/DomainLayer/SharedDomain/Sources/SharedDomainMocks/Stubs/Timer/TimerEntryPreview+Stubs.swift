//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension TimerEntryPreview {
    static func stub(id: String = UUID().uuidString) -> TimerEntryPreview {
        TimerEntryPreview(
            id: id,
            project: .stub(),
            client: .stub(),
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. \(id)",
            startedAt: Date(timeIntervalSinceNow: -200_000).asInstant,
            endedAt: Date.now.asInstant
        )
    }
}

public extension [TimerEntryPreview] {
    static var stub: [TimerEntryPreview] {
        (0..<15).map { id in .stub(id: "\(id)") }
    }
}
