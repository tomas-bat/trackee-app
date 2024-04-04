//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static func primary(
        image: Image? = nil,
        expanded: Bool = true
    ) -> Self {
        return .init(
            image: image,
            expanded: expanded
        )
    }
    
    static var primary: Self {
        return primary()
    }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: Self {
        .init()
    }
}

public extension ButtonStyle where Self == LoadingButtonStyle {
    static var loading: Self {
        .init()
    }
}
