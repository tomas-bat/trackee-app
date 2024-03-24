//
//  Created by Petr Chmelar on 28.02.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SwiftUI
import Utilities

public struct PrimaryButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private let imageSize: CGFloat = 18
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    private var height: CGFloat { imageSize + 2*padding }
    private let pressedOpacity: CGFloat = 0.5
    
    // MARK: - Stored properties
    
    private let image: Image?
    private let expanded: Bool
    
    @SwiftUI.Environment(\.isLoading) private var isLoading
    
    // MARK: - Init
    
    public init(
        image: Image? = nil,
        expanded: Bool = true
    ) {
        self.image = image
        self.expanded = expanded
    }
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
            }
            
            if expanded {
                Spacer()
            }
            
            configuration.label
                .foregroundStyle(AppTheme.Colors.foreground)
                .font(AppTheme.Fonts.headline)
                .opacity(isLoading ? 0 : 1)
                .if(isLoading) { label in
                    label.overlay(
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(
                                    tint: AppTheme.Colors.foreground
                                )
                            )
                    )
                }
            
            if expanded {
                Spacer()
            }
            
            if image != nil, expanded {
                Color.clear
                    .frame(width: imageSize)
            }
        }
        .padding(padding)
        .frame(height: height)
        .background(
            AppTheme.Colors.field
        )
        .clipShape(
            RoundedRectangle(
                cornerSize: .init(
                    width: height / 2,
                    height: height / 2
                )
            )
        )
        .opacity(configuration.isPressed ? pressedOpacity : 1)
        .allowsHitTesting(!isLoading)
        .animateContent(isLoading)
    }
}

#if DEBUG
struct PrimaryButtonStyle_Preview: PreviewProvider {
    struct PreviewView: View {
        @State var isLoading = false
        
        var body: some View {
            Button("Click me", action: action)
                .buttonStyle(.primary(
                    image: Image(systemSymbol: .applewatch),
                    expanded: true
                ))
                .padding()
                .environment(\.isLoading, isLoading)
        }
        
        @MainActor 
        func action() {
            isLoading = true
            _ = Task.delayed(byTimeInterval: 2) {
                isLoading = false
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif
