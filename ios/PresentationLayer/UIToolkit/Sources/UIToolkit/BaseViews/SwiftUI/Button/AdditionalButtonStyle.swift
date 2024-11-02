//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//


import SwiftUI

public struct AdditionalButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private let pressedOpacity: CGFloat = 0.5
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.Fonts.index)
            .foregroundStyle(AppTheme.Colors.foregroundSecondary)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
    }
}

#if DEBUG
#Preview {
    Button("Lorem Ipsum") {}
        .buttonStyle(.additional)
}
#endif
