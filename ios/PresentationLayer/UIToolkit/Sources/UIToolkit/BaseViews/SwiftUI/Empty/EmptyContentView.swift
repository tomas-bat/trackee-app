//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct EmptyContentView: View {
    
    // MARK: - Constants
    
    // MARK: - Stored properties
    
    private let text: String
    
    // MARK: - Init
    
    public init(
        text: String = L10n.empty_list
    ) {
        self.text = text
    }
    
    // MARK: - Body
    
    public var body: some View {
        Text(text)
            .font(AppTheme.Fonts.headlineAdditional)
            .foregroundStyle(AppTheme.Colors.foreground)
            .multilineTextAlignment(.center)
    }
}

#if DEBUG
#Preview {
    EmptyContentView()
}
#endif
