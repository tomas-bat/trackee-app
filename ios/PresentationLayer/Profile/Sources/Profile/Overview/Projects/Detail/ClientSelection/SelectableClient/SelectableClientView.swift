//
//  Created by Tomáš Batěk on 04.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct SelectableClientView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let client: Client
    private let isSelected: Bool
    
    // MARK: - Init
    
    init(
        client: Client,
        isSelected: Bool
    ) {
        self.client = client
        self.isSelected = isSelected
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            Text(client.name)
                .font(AppTheme.Fonts.headline)
            
            Spacer()
            
            Image(systemSymbol: .checkmark)
                .resizable()
                .scaledToFit()
                .frame(height: imageSize)
                .opacity(isSelected ? 1 : 0)
        }
        .padding(padding)
        .background(AppTheme.Colors.contentBackground)
        .clipShape(RoundedRectangle(cornerSize: cornerRadius.squared))
        .foregroundStyle(AppTheme.Colors.foreground)
    }
}

#if DEBUG
import SharedDomainMocks

#Preview {
    VStack {
        Spacer()
        
        SelectableClientView(
            client: .stub(),
            isSelected: false
        )
        
        Spacer()
    }
    .padding()
    .background(AppTheme.Colors.background)
}
#endif

