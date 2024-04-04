//
//  Created by Tomáš Batěk on 04.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct LoadingView: View {
    
    // MARK: - Stored properties
    
    private let tint: Color
    
    // MARK: - Init
    
    
    public init(
        tint: Color = AppTheme.Colors.foreground
    ) {
        self.tint = tint
    }
    
    // MARK: - Body
    
    public var body: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(
                    tint: tint
                )
            )
    }
}

#if DEBUG
#Preview {
    LoadingView()
}
#endif
