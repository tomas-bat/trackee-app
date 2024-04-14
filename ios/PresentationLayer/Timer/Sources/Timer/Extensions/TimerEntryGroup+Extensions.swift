//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import Utilities

extension TimerEntryGroup: Identifiable {
    var formattedInterval: String? {
        guard let interval = interval?.int else { return nil }
        let formatter = Formatter.DateComponents.default
        let baseDate = Date.now
        return formatter.string(from: baseDate, to: baseDate.addingTimeInterval(Double(interval)))
    }
}
