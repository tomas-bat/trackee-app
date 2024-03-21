//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import KMPSharedDomain

struct TimerEntryView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let headerHorizontalSpacing: CGFloat = 4
    private let headerVerticalSpacing: CGFloat = 4
    private let imageSize: CGFloat = 22
    
    // MARK: - Stored properties
    
    private let timerEntry: TimerEntry
    
    // MARK: - Init
    
    init(timerEntry: TimerEntry) {
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
                
                VStack(spacing: headerVerticalSpacing) {
                    
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    TimerEntryView(
        timerEntry: .stub()
    )
}
#endif
