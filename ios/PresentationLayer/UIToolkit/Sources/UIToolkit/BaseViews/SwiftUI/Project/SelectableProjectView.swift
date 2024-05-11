//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain

public struct SelectableProjectView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let project: ProjectPreview
    private let isSelected: Bool
    
    // MARK: - Init
    
    public init(
        project: ProjectPreview,
        isSelected: Bool
    ) {
        self.project = project
        self.isSelected = isSelected
    }
    
    // MARK: - Body
    
    public var body: some View {
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
                .multilineTextAlignment(.leading)
            }
            
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
        
        SelectableProjectView(
            project: .stub(),
            isSelected: false
        )
        
        SelectableProjectView(
            project: ProjectPreview(
                id: "project_id",
                client: Client(
                    id: "client_id",
                    name: "Interestingly longly named unintersting company"
                ),
                type: .school,
                name: "Unexpectedly significantly named extravagant experience"
            ),
            isSelected: true
        )
        
        Spacer()
    }
    .padding()
    .background(AppTheme.Colors.background)
}
#endif
