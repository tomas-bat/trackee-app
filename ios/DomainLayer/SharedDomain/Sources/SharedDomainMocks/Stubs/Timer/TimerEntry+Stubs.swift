//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension TimerEntry {
    static func stub(id: String = UUID().uuidString) -> TimerEntry {
        TimerEntry(
            id: id,
            clientId: "client_\(id)",
            projectId: "project_\(id)",
            description: "Lorem ipsum dolor sit amet",
            startedAt: Date(timeIntervalSinceNow: -20_000).asInstant,
            endedAt: Date.now.asInstant,
            clockifyEntryId: nil,
            clockifyWorkspaceId: nil
        )
    }
}
