//
//  Created by Tomáš Batěk on 28.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation

public extension BinaryFloatingPoint {
    /// Returns normalized value for the range between `a` and `b`
    /// - Parameters:
    ///   - min: minimum of the range of the measurement
    ///   - max: maximum of the range of the measurement
    ///   - a: minimum of the range of the scale
    ///   - b: minimum of the range of the scale
    /// - Note: Solution from https://gist.github.com/mcichecki/bf8808f123ce342b17058abcca3b5378
    func normalize(min: Self, max: Self, from a: Self = 0, to b: Self = 1) -> Self {
        (b - a) * ((self - min) / (max - min)) + a
    }
    
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
