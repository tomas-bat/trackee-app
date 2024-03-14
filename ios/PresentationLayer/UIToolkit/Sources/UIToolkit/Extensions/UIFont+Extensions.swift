//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public extension UIFont {
    class func preferredFont(forTextStyle style: TextStyle, weight: Weight = .regular, size: CGFloat? = nil) -> Font {
        // 1
        let metrics = UIFontMetrics(forTextStyle: style)
        // 2
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let defaultSize = descriptor.pointSize
        // 3
        let fontToScale = UIFont.systemFont(ofSize: size ?? defaultSize, weight: weight)
        // 4
        return Font(metrics.scaledFont(for: fontToScale))
    }
}

