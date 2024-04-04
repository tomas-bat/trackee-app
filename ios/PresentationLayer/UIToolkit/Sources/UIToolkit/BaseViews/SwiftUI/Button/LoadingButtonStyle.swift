//
//  Created by Tomáš Batěk on 03.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct LoadingButtonStyle: ButtonStyle {
    
    private let pressedOpacity: CGFloat = 0.5
    
    @Environment(\.isLoading) private var isLoading
    
    public func makeBody(configuration: Configuration) -> some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(
                            tint: AppTheme.Colors.foreground
                        )
                    )
            } else {
                configuration.label
                    .opacity(configuration.isPressed ? pressedOpacity : 1)
            }
        }
        .allowsHitTesting(!isLoading)
        .animateContent(isLoading)
    }
}
