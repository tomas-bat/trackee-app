//
//  Created by Tomáš Batěk on 19.10.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import Utilities

public struct SignInWithAppleButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private let imageSize: CGFloat = 18
    private let padding: CGFloat = 16
    private let imagePadding: CGFloat = 8
    private let spacing: CGFloat = 8
    private var height: CGFloat { imageSize + 2*padding }
    private let pressedOpacity: CGFloat = 0.5
    
    // MARK: - Stored properties
    
    private let expanded: Bool
    
    @SwiftUI.Environment(\.isLoading) private var isLoading
    
    // MARK: - Init
    
    init(expanded: Bool = true) {
        self.expanded = expanded
    }
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            Image(systemSymbol: .appleLogo)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .padding(.leading, imagePadding)
            
            if expanded {
                Spacer()
            }
            
            configuration.label
                .font(AppTheme.Fonts.headline)
                .opacity(isLoading ? 0 : 1)
                .if(isLoading) { label in
                    label.overlay(
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(
                                    tint: AppTheme.Colors.appleButtonForeground
                                )
                            )
                    )
                }
            
            if expanded {
                Spacer()
            }
            
            if expanded {
                Color.clear
                    .frame(width: imageSize)
                    .padding(.trailing, imagePadding)
            }
        }
        .foregroundStyle(AppTheme.Colors.appleButtonForeground)
        .padding(padding)
        .frame(height: height)
        .background(
            AppTheme.Colors.appleButtonBackground
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
struct SignInWithAppleButtonStyle_Preview: PreviewProvider {
    struct PreviewView: View {
        @State var isLoading = false
        
        var body: some View {
            Button("Click me", action: action)
                .buttonStyle(.signInWithApple(expanded: true))
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
