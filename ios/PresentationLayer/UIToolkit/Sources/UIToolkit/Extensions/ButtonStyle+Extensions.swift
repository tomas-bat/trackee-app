//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static func primary(
        image: Image? = nil,
        backgroundColor: Color = AppTheme.Colors.field,
        expanded: Bool = true
    ) -> Self {
        return .init(
            image: image,
            backgroundColor: backgroundColor,
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

public extension ButtonStyle where Self == FetchMoreButtonStyle {
    static var fetchMore: Self {
        .init()
    }
}

public extension ButtonStyle where Self == SignInWithAppleButtonStyle {
    static func signInWithApple(expanded: Bool = true) -> Self {
        .init(expanded: expanded)
    }
    
    static var signInWithApple: Self {
        .init()
    }
}

public extension ButtonStyle where Self == AdditionalButtonStyle {
    static var additional: Self {
        .init()
    }
}
