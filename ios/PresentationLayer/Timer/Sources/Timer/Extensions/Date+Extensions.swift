//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import UIToolkit

extension Date {
    var localizedDate: String {
        guard !Calendar.current.isDateInToday(self) else {
            return L10n.timer_view_today
        }
        
        let formatter = DateFormatter()
        
        var format: String {
            if Calendar.current.isDate(
                self,
                equalTo: Date.now,
                toGranularity: .year
            ) {
                return "d. MMMM"
            }
            return "d. MMMM YYYY"
        }
        
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
