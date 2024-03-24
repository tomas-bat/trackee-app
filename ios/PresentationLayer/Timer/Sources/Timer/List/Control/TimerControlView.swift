//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct TimerControlView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let selectorHorizontalSpacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let chevronSize: CGFloat = 14
    
    // MARK: - Stored properties
    
    private let data: TimerDataPreview
    private let onControlClick: () -> Void
    private let onSwitchClick: () -> Void
    private let onDeleteClick: () -> Void
    private let onStartChange: (Date) -> Void
    private let onEndChange: (Date) -> Void
    private let onProjectChange: (Project) -> Void
    private let onDescriptionChange: (String?) -> Void
    
    // MARK: - Init
    
    init(
        data: TimerDataPreview,
        onControlClick: @escaping () -> Void,
        onSwitchClick: @escaping () -> Void,
        onDeleteClick: @escaping () -> Void,
        onStartChange: @escaping (Date) -> Void,
        onEndChange: @escaping (Date) -> Void,
        onProjectChange: @escaping (Project) -> Void,
        onDescriptionChange: @escaping (String?) -> Void
    ) {
        self.data = data
        self.onControlClick = onControlClick
        self.onSwitchClick = onSwitchClick
        self.onDeleteClick = onDeleteClick
        self.onStartChange = onStartChange
        self.onEndChange = onEndChange
        self.onProjectChange = onProjectChange
        self.onDescriptionChange = onDescriptionChange
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: spacing) {
            projectSelector
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
    
    // MARK: - Private
    
    private var projectSelector: some View {
        Button {
            
        } label: {
            HStack(spacing: selectorHorizontalSpacing) {
                if let client = data.client, let project = data.project {
                    if let type = project.type {
                        type.image
                            .resizable()
                            .scaledToFit()
                            .frame(height: imageSize)
                    }
                    
                    Text(project.name)
                        .font(AppTheme.Fonts.headline)
                    
                    Text(client.name)
                        .font(AppTheme.Fonts.headlineAdditional)
                        .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                    
                    Image(systemSymbol: .chevronDown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: chevronSize)
                }
            }
        }
    }
}

#if DEBUG
import DependencyInjectionMocks

#Preview {
    TimerControlView(
        data: .stub,
        onControlClick: {},
        onSwitchClick: {},
        onDeleteClick: {},
        onStartChange: { _ in },
        onEndChange: { _ in },
        onProjectChange: { _ in },
        onDescriptionChange: { _ in }
    )
}
#endif
