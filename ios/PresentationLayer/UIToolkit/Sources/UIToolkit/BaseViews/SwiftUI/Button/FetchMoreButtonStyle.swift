//
//  Created by Tomáš Batěk on 12.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct FetchMoreButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private let pressedOpacity: CGFloat = 0.5
    private let padding: CGFloat = 10
    private let height: CGFloat = 40
    
    // MARK: - Stored properties

    @Environment(\.isLoading) private var isLoading
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(height: height, alignment: .center)
                    .allowsHitTesting(false)
            } else {
                configuration.label
                    .font(AppTheme.Fonts.headlineAdditional)
                    .padding(padding)
                    .frame(height: height, alignment: .center)
                    .background(AppTheme.Colors.field)
                    .clipShape(RoundedRectangle(cornerRadius: height / 2))
                    .opacity(configuration.isPressed ? pressedOpacity : 1)
            }
            
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    Button("Fetch more...") {}
        .buttonStyle(.fetchMore)
        .environment(\.isLoading, false)
}
#endif
