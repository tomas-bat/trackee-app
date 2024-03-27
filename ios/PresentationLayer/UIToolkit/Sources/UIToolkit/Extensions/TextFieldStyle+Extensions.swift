//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import SFSafeSymbols

public extension TextFieldStyle where Self == InfoTextFieldStyle {
    static var info: Self {
        .init()
    }
}

public extension TextFieldStyle where Self == PrimaryTextFieldStyle {
    static func primary(image: Image) -> Self {
        .init(image: image)
    }
}

public extension TextFieldStyle where Self == PasswordTextFieldStyle {
    static func password(
        image: Image = Image(systemSymbol: .lock),
        passwordShown: Bool,
        onShowTap: @escaping () -> Void
    ) -> Self {
        .init(
            image: image,
            passwordShown: passwordShown,
            onShowTap: onShowTap
        )
    }
}
