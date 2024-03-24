//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct ErrorView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let error: Error
    private let onRetryTap: (() -> Void)?
    
    // MARK: - Init
    
    public init(
        error: Error,
        onRetryTap: (() -> Void)? = nil
    ) {
        self.error = error
        self.onRetryTap = onRetryTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: spacing) {
            Text(error.localizedDescription)
            
            Button(L10n.retry) {
                onRetryTap?()
            }
        }
        .font(AppTheme.Fonts.headline)
        .foregroundStyle(AppTheme.Colors.foreground)
        .multilineTextAlignment(.center)
        .buttonStyle(.primary)
    }
}

#if DEBUG
import KMPSharedDomain

#Preview {
    ErrorView(
        error: AuthError.CredentialLoginFailed().asError
    )
}
#endif
