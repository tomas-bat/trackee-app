//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import Utilities
import UIToolkit

extension TimerSummary: Identifiable {
    var formattedInterval: String? {
        let formatter = Formatter.DateComponents.default
        let baseDate = Date.now
        return formatter.string(from: baseDate, to: baseDate.addingTimeInterval(Double(interval)))
    }
    
    var formattedComponent: String {
        switch component {
        case .today: L10n.timer_view_summary_today
        case .thisWeek: L10n.timer_view_summary_this_week
        }
    }
}
