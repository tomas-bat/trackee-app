//
//  Created by Petr Chmelar on 28.02.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private let pressedOpacity: CGFloat = 0.5
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Fonts.headline)
            .foregroundStyle(AppTheme.Colors.foreground)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
    }
}

#if DEBUG
#Preview {
    Button("Lorem Ipsum") {}
        .buttonStyle(SecondaryButtonStyle())
}
#endif
