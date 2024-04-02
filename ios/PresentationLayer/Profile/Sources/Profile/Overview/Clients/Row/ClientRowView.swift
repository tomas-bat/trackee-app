//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ClientRowView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let client: Client
    private let onClick: () -> Void
    
    // MARK: - Init
    
    init(
        client: Client,
        onClick: @escaping () -> Void
    ) {
        self.client = client
        self.onClick = onClick
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                Text(client.name)
                    .font(AppTheme.Fonts.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(AppTheme.Colors.foreground)
                    .padding()
                
                Spacer()
            }
            .background(AppTheme.Colors.contentBackground)
            .clipShape(RoundedRectangle(cornerSize: cornerRadius.squared))
        }
    }
}

#if DEBUG
#Preview {
    ClientRowView(
        client: .stub(),
        onClick: {}
    )
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTheme.Colors.background)
}
#endif
