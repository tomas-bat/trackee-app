//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension TimerDataPreview {
    static var stub: TimerDataPreview {
        TimerDataPreview(
            status: .active,
            type: .manual,
            client: .stub(),
            project: .stub(),
            description: "Lorem ipsum dolor sit amet.",
            startedAt: Date(timeIntervalSinceNow: -20_000).asInstant,
            availableProjects: .stub
        )
    }
}
