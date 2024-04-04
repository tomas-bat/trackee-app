//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension TimerEntryGroup {
    static var stub: TimerEntryGroup {
        TimerEntryGroup(
            date: Date.now.asLocalDate,
            entries: .stub
        )
    }
}

public extension [TimerEntryGroup] {
    static var stub: [TimerEntryGroup] {
        [
            TimerEntryGroup(
                date: Date.now.asLocalDate,
                entries: .stub
            ),
            TimerEntryGroup(
                date: Date(timeIntervalSinceNow: -90_000).asLocalDate,
                entries: .stub
            ),
            TimerEntryGroup(
                date: Date(timeIntervalSinceNow: -180_000).asLocalDate,
                entries: .stub
            ),
            TimerEntryGroup(
                date: Date(timeIntervalSinceNow: -270_000).asLocalDate,
                entries: .stub
            ),
            TimerEntryGroup(
                date: Date(timeIntervalSinceNow: -32_270_000).asLocalDate,
                entries: .stub
            )
        ]
        .reversed()
    }
}