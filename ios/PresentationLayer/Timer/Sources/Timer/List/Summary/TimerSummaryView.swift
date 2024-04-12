//
//  Created by Tomáš Batěk on 22.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct TimerSummaryView: View {
    
    // MARK: - Constants
    
    private let summaryVerticalSpacing: CGFloat = 4
    private let summaryHorizontalSpacing: CGFloat = 4
    
    // MARK: - Stored properties
    
    private let summaries: [TimerSummaryViewObject]
    
    // MARK: - Init
    
    init(
        summaries: [TimerSummaryViewObject]
    ) {
        self.summaries = summaries
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: summaryVerticalSpacing) {
            ForEach(summaries.indices, id: \.self) { idx in
                let summary = summaries[idx]
                
                if let interval = summary.formattedTime {
                    HStack(spacing: summaryHorizontalSpacing) {
                        Text(interval)
                            .font(AppTheme.Fonts.headline)
                            .foregroundStyle(AppTheme.Colors.foreground)
                        
                        Text(summary.summary.formattedComponent)
                            .font(AppTheme.Fonts.headlineAdditional)
                            .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                    }
                }
            }
        }
    }
    
    private var padding: some View {
        // Workaround for nav bar padding
        Text("")
    }
}

#if DEBUG
import SharedDomainMocks

#Preview {
    TimerSummaryView(
        summaries: .stub
    )
    .previewLayout(.sizeThatFits)
}
#endif
