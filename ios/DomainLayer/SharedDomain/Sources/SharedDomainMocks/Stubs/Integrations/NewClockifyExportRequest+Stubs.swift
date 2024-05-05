//
//  Created by Tomáš Batěk on 05.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain

public extension NewClockifyExportRequest {
    var stub: NewClockifyExportRequest {
        NewClockifyExportRequest(
            apiKey: .randomString(),
            workspaceName: .randomString(),
            from: Date.distantPast.asInstant,
            to: Date.now.asInstant
        )
    }
}
