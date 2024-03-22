//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension TimerSummary {
    static var stub: TimerSummary {
        TimerSummary(
            component: .today,
            interval: 12345
        )
    }
}

public extension [TimerSummary] {
    static var stub: [TimerSummary] {
        [
            TimerSummary(
                component: .today,
                interval: 12345
            ),
            TimerSummary(
                component: .thisWeek,
                interval: 123456
            )
        ]
    }
}
