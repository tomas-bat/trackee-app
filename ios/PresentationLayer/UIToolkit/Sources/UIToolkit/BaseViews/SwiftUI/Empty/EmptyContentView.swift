//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct EmptyContentView: View {
    
    public struct Action {
        public let label: String
        public let image: Image?
        public let action: () -> Void
        
        public init(
            label: String,
            image: Image? = nil,
            action: @escaping () -> Void
        ) {
            self.label = label
            self.image = image
            self.action = action
        }
    }
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 32
    
    // MARK: - Stored properties
    
    private let text: String
    private let action: Action?
    
    // MARK: - Init
    
    public init(
        text: String = L10n.empty_list,
        action: Action? = nil
    ) {
        self.text = text
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            Text(text)
                .font(AppTheme.Fonts.headlineAdditional)
                .foregroundStyle(AppTheme.Colors.foreground)
                .multilineTextAlignment(.center)
            
            if let action {
                Button(action: action.action) {
                    Text(action.label)
                }
                .buttonStyle(.action(image: action.image))
            }
        }
    }
}

#if DEBUG
#Preview {
    EmptyContentView(
        action: .init(
            label: "Add",
            image: Image(systemSymbol: .plus),
            action: {}
        )
    )
}
#endif
