//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension TimerEntryPreview {
    static func stub(
        id: String = UUID().uuidString,
        description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        project: Project = .stub(),
        client: Client = .stub()
    ) -> TimerEntryPreview {
        TimerEntryPreview(
            id: id,
            project: project,
            client: client,
            description: description,
            startedAt: Date(timeIntervalSinceNow: -200_000).asInstant,
            endedAt: Date.now.asInstant,
            clockifyEntryId: "clockify_entry_\(id)",
            clockifyWorkspaceId: "clockify_workspace_id"
        )
    }
}

public extension [TimerEntryPreview] {
    static var stub: [TimerEntryPreview] {
        (0..<15).map { id in .stub(id: "\(id)") }
    }
}
