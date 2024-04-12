//
//  Created by Tomáš Batěk on 11.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import Utilities

struct TimerSummaryViewObject: Equatable {
    
    let summary: TimerSummary
    let formattedTime: String?
    
    init(summary: TimerSummary) {
        self.summary = summary
        self.formattedTime = summary.formattedInterval
    }
    
    private init(
        summary: TimerSummary,
        formattedTime: String?
    ) {
        self.summary = summary
        self.formattedTime = formattedTime
    }
    
    func adding(_ interval: TimeInterval) -> TimerSummaryViewObject {
        let formatter = Formatter.DateComponents.default
        let baseDate = Date.now
        
        return TimerSummaryViewObject(
            summary: summary,
            formattedTime: formatter.string(
                from: baseDate,
                to: baseDate.addingTimeInterval(Double(TimeInterval(summary.interval) + interval))
            )
        )
    }
    
    static func == (lhs: TimerSummaryViewObject, rhs: TimerSummaryViewObject) -> Bool {
        lhs.summary == rhs.summary && lhs.formattedTime == rhs.formattedTime
    }
}

extension TimerSummary {
    var asViewObject: TimerSummaryViewObject {
        TimerSummaryViewObject(summary: self)
    }
}

extension [TimerSummaryViewObject] {
    static var stub: [TimerSummaryViewObject] {
        [TimerSummary].stub.map { $0.asViewObject }
    }
}
