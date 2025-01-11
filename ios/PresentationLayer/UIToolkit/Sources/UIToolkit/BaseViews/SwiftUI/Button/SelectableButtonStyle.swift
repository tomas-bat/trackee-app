//
//  Created by Tomáš Batěk on 01.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI

public struct SelectableButtonStyle<Badge: View>: ButtonStyle {
    
    // MARK: - Constants
    
    private let imageSize: CGFloat = 16
    private let spacing: CGFloat = 8
    private let padding: CGFloat = 16
    private let pressedOpacity: CGFloat = 0.5
    private let lineWidth: CGFloat = 1
    private var height: CGFloat { imageSize + 2*padding }
    
    // MARK: - Stored properties
    
    private let badge: Badge?
    private let expanded: Bool
    private let selected: Bool
    
    @SwiftUI.Environment(\.isLoading) private var isLoading
    
    // MARK: - Init
    
    public init(
        selected: Bool,
        expanded: Bool = true,
        @ViewBuilder badge: () -> Badge?
    ) {
        self.selected = selected
        self.expanded = expanded
        self.badge = badge()
    }
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: spacing) {
            if selected {
                Image(systemSymbol: .checkmark)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
            }
            
            if expanded {
                Spacer()
            }
                
            configuration.label
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
                
                if selected {
                    Color.clear
                        .frame(width: imageSize)
                }
            }
        }
        .padding(padding)
        .frame(height: height)
        .background(
            AppTheme.Colors.contentBackground
        )
        .clipShape(Capsule())
        .opacity(configuration.isPressed ? pressedOpacity : 1)
        .allowsHitTesting(!isLoading)
        .animateContent(isLoading)
        .if(selected) { button in
            button.overlay(
                Capsule()
                    .stroke(AppTheme.Colors.foreground, lineWidth: lineWidth)
            )
        }
        .if(badge != nil) { button in
            button.overlay(alignment: .topTrailing) {
                if let badge {
                    badge
                }
            }
        }
    }
}

public extension SelectableButtonStyle where Badge == Never {
    init(
        selected: Bool,
        expanded: Bool = true
    ) {
        self.selected = selected
        self.expanded = expanded
        self.badge = nil
    }
}

#if DEBUG
struct PreviewView: View {
    
    @State var selected: Bool = false
    
    var body: some View {
        VStack {
            Button("Selectable button") {
                selected.toggle()
            }
            .buttonStyle(SelectableButtonStyle(selected: selected))
            .padding()
        }
        .background(AppTheme.Colors.background)
    }
}

#Preview {
    PreviewView()
}
#endif
