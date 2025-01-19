//
//  Created by Tomáš Batěk on 12.01.2025
//  Copyright © 2025 Matee. All rights reserved.
//

import SwiftUI

public struct ActionButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private let pressedOpacity: CGFloat = 0.5
    private let verticalPadding: CGFloat = 8
    private let horizontalPadding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let spacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @Environment(\.isLoading) private var isLoading
    
    private let image: Image?
    private let expanded: Bool
    
    // MARK: - Init
    
    public init(
        image: Image? = nil,
        expanded: Bool = false
    ) {
        self.image = image
        self.expanded = expanded
    }
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            if let image {
                image
                    .opacity(isLoading ? 0 : 1)
            }
            
            if expanded {
                Spacer()
            }
    
            configuration.label
                .font(AppTheme.Fonts.headline)
                .opacity(isLoading ? 0 : 1)

            if expanded {
                Spacer()
            }
            
            if let image, expanded {
                image.opacity(.zero)
            }
        }
        .overlay(
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: AppTheme.Colors.onAction
                            )
                        )
                }
            }
            .opacity(isLoading ? 1 : 0)
        )
        .foregroundStyle(AppTheme.Colors.onAction)
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(
            AppTheme.Colors.action
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .opacity(configuration.isPressed ? pressedOpacity : 1)
        .allowsHitTesting(!isLoading)
        .animateContent(isLoading)
    }
}

#if DEBUG
#Preview {
    Button("Lorem Ipsum") {}
        .buttonStyle(.action(
            image: Image(systemSymbol: .plus),
            expanded: false
        ))
        .environment(\.isLoading, false)
}
#endif


