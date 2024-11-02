//
//  Created by Tomáš Batěk on 28.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import UIToolkit

struct TimerControlButton: View {
    
    enum `Type` {
        case start
        case stop
        case add
        case timer
        case discard
    }
    
    // MARK: - Constants
    
    private var imageSize: CGFloat {
        isLarge ? 26 : 24
    }
    
    private var buttonSize: CGFloat {
        isLarge ? 62 : 50
    }
    
    // MARK: - Stored properties
    
    private let type: `Type`
    private let isLoading: Bool
    private let isLarge: Bool
    private let action: () -> Void
    
    // MARK: - Init
    
    init(
        type: `Type`,
        isLoading: Bool,
        isLarge: Bool = false,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.isLoading = isLoading
        self.isLarge = isLarge
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: imageSize, height: imageSize)
            .frame(width: buttonSize, height: buttonSize)
            .background(backgroundColor)
            .clipShape(Circle())
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
    
    // MARK: - Private
    
    private var backgroundColor: Color {
        switch type {
        case .start: AppTheme.Colors.success
        case .stop: AppTheme.Colors.destructive
        default: AppTheme.Colors.field
        }
    }
    
    private var image: Image {
        switch type {
        case .start: Image(systemSymbol: .playFill)
        case .stop: Image(systemSymbol: .stopFill)
        case .add: Image(systemSymbol: .plus)
        case .timer: Image(systemSymbol: .timer)
        case .discard: Image(systemSymbol: .trash)
        }
    }
}

#if DEBUG

struct PreviewView: View {
    
    @State var isLoading = false
    
    var body: some View {
        TimerControlButton(
            type: .add,
            isLoading: isLoading,
            isLarge: false,
            action: {
                isLoading = true
                _ = Task.delayed(byTimeInterval: 2) {
                    isLoading = false
                }
            }
        )
    }
}

#Preview {
    PreviewView()
}
#endif
