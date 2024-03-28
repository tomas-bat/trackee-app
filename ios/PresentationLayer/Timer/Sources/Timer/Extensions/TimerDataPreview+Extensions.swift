//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

extension TimerDataPreview {
    convenience init(
        copy: TimerDataPreview,
        type: TimerType? = nil,
        status: TimerStatus? = nil,
        client: Client? = nil,
        project: Project? = nil,
        description: String? = nil,
        startedAt: Kotlinx_datetimeInstant? = nil,
        removeStartTime: Bool = false
    ) {
        self.init(
            status: status ?? copy.status,
            type: type ?? copy.type,
            client: client ?? copy.client,
            project: project ?? copy.project,
            description: description ?? copy.description_,
            startedAt: removeStartTime ? nil : (startedAt ?? copy.startedAt)
        )
    }
    
    var rawTimerData: TimerData {
        TimerData(
            status: status,
            clientId: client?.id,
            projectId: project?.id,
            description: description_,
            startedAt: startedAt
        )
    }
}
