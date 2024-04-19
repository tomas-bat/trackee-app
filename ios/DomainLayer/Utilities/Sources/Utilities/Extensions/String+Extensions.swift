//
//  Created by Petr Chmelar on 23/07/2018.
//  Copyright © 2018 Matee. All rights reserved.
//

import Foundation

public extension String {
    /// Conversion from String to Date using a given formatter.
    func toDate(formatter: DateFormatter = Formatter.Date.default) -> Date? {
        formatter.date(from: self)
    }
    
    static func randomString(length: Int = (4...26).randomElement() ?? 4) -> String { // (4...26) preffered word width
        let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return String(
            (0..<length).map { _ in
                if let char = letters.randomElement() {
                    return char
                }
                return "a"
            }
        )
    }
}
