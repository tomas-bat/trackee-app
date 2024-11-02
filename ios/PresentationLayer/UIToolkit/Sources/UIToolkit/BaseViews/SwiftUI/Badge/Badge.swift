//
//  Created by Tomáš Batěk on 02.11.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI

public struct Badge: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 12
    private let padding = EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    
    // MARK: - Stored properties
    
    private let text: String
    private let image: Image?
    
    // MARK: - Init
    
    public init(
        text: String,
        image: Image? = nil
    ) {
        self.text = text
        self.image = image
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: imageSize)
            }
            
            Text(text)
                .font(AppTheme.Fonts.index)
        }
        .foregroundStyle(AppTheme.Colors.onDestructive)
        .padding(padding)
        .background(AppTheme.Colors.destructive)
        .clipShape(Capsule())
    }
}

#if DEBUG
#Preview {
    Badge(
        text: "Best offer",
        image: Image(systemSymbol: .starFill)
    )
}
#endif
