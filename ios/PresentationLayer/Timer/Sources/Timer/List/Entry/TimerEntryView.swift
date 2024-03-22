//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import KMPSharedDomain
import UIToolkit
import SharedDomain

struct TimerEntryView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let headerHorizontalSpacing: CGFloat = 4
    private let headerVerticalSpacing: CGFloat = 4
    private let imageSize: CGFloat = 16
    private let timeIntervalStackSpacing: CGFloat = 1
    private let padding: CGFloat = 16
    private let cornerRadius: CGSize = CGFloat(8).squared
    
    // MARK: - Stored properties
    
    private let timerEntry: TimerEntryPreview
    
    // MARK: - Init
    
    init(timerEntry: TimerEntryPreview) {
        self.timerEntry = timerEntry
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(alignment: .top, spacing: headerHorizontalSpacing) {
                Image(systemSymbol: .briefcase)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                
                VStack(alignment: .leading, spacing: headerVerticalSpacing) {
                    Text(timerEntry.project.name)
                        .font(AppTheme.Fonts.headline)
                    
                    Text(timerEntry.client.name)
                        .font(AppTheme.Fonts.headlineAdditional)
                        .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                }
            }
            
            if let description = timerEntry.description_ {
                Text(description)
                    .font(AppTheme.Fonts.body)
            }
            
            HStack {
                HStack(alignment: .top, spacing: timeIntervalStackSpacing) {
                    Text(timerEntryInterval.localizedRange.time)
                    
                    if let extra = timerEntryInterval.localizedRange.extra {
                        Text(extra)
                            .font(AppTheme.Fonts.index)
                    }
                }
                
                Spacer()
                
                if let interval = timerEntryInterval.localizedInterval {
                    Text(interval)
                }
            }
            .font(AppTheme.Fonts.headline)
        }
        .padding(padding)
        .background(AppTheme.Colors.contentBackground)
        .clipShape(
            RoundedRectangle(cornerSize: cornerRadius)
        )
        .multilineTextAlignment(.leading)
        .foregroundStyle(AppTheme.Colors.foreground)
    }
    
    // MARK: - Private
    
    private var timerEntryInterval: TimerEntryInterval {
        TimerEntryInterval(
            start: timerEntry.startedAt.asDate,
            end: timerEntry.endedAt.asDate
        )
    }
}

#if DEBUG
#Preview {
    TimerEntryView(
        timerEntry: .stub()
    )
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTheme.Colors.background)
}
#endif
