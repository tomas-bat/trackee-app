//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import Utilities

public struct TimerEntryInterval {
    
    public struct LocalizedRange {
        public let time: String
        public let extra: String?
    }
    
    public let start: Date
    public let end: Date
    
    public init(
        start: Date,
        end: Date
    ) {
        self.start = start
        self.end = end
    }
    
    public var localizedRange: LocalizedRange {
        let formatter = Formatter.Date.timeOnly
        
        let startTime = formatter.string(from: start)
        let endTime = formatter.string(from: end)
        
        let diff = end.timeIntervalSince(start)
    
        let daysDiff = Int(floor((diff / 86_400)))
        
        return LocalizedRange(
            time: "\(startTime) – \(endTime)",
            extra: daysDiff > 0 ? "+\(daysDiff)" : nil
        )
    }
    
    public var localizedInterval: String? {
        let formatter = Utilities.Formatter.DateComponents.default
        return formatter.string(from: start, to: end)
    }
}
