//
//  Created by Tomáš Batěk on 17.08.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct TimerEntryProjectView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let colorCircleSize: CGFloat = 10
    private let typeImageOffset: CGFloat = 2
    
    // MARK: - Stored properties
    
    private let project: ProjectPreview
    
    // MARK: - Init
    
    init(
        project: ProjectPreview
    ) {
        self.project = project
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                if let type = project.type {
                    VStack {
                        type.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                            .offset(y: typeImageOffset)
                    }
                }
                
                VStack(alignment: .leading, spacing: spacing) {
                    HStack(alignment: .firstTextBaseline, spacing: spacing) {
                        Text(project.name)
                            .font(AppTheme.Fonts.headline)
                        
                        if let color = project.color {
                            color.circle
                                .frame(width: colorCircleSize, height: colorCircleSize)
                        }
                    }
                    
                    Text(project.client.name)
                        .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                        .font(AppTheme.Fonts.headlineAdditional)
                }
                .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemSymbol: .chevronRight)
                .resizable()
                .scaledToFit()
                .frame(height: imageSize)
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
        
        TimerEntryProjectView(
            project: .stub()
        )
        
        TimerEntryProjectView(
            project: ProjectPreview(
                id: "project_id",
                client: Client(
                    id: "client_id",
                    name: "Interestingly longly named unintersting company"
                ),
                type: .school,
                name: "Unexpectedly significantly named extravagant experience",
                color: ProjectColor.allCases.randomElement()
            )
        )
        
        Spacer()
    }
    .padding()
    .background(AppTheme.Colors.background)
}
#endif
