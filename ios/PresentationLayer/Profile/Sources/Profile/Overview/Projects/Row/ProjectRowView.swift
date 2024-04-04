//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ProjectRowView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    
    // MARK: - Stored properties
    
    private let project: ProjectPreview
    private let onClick: () -> Void
    
    // MARK: - Init
    
    init(
        project: ProjectPreview,
        onClick: @escaping () -> Void
    ) {
        self.project = project
        self.onClick = onClick
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center, spacing: spacing) {
                HStack(alignment: .top, spacing: spacing) {
                    if let type = project.type {
                        VStack {
                            type.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize, height: imageSize)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: spacing) {
                        Text(project.name)
                            .font(AppTheme.Fonts.headline)
                        
                        Text(project.client.name)
                            .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                            .font(AppTheme.Fonts.headlineAdditional)
                    }
                }
                
                Spacer()
            }
            .padding(padding)
            .background(AppTheme.Colors.contentBackground)
            .clipShape(RoundedRectangle(cornerSize: cornerRadius.squared))
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
}

#if DEBUG
#Preview {
    ProjectRowView(
        project: .stub(),
        onClick: {}
    )
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTheme.Colors.background)
}
#endif
