//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import KMPSharedDomain
import UIToolkit
import SharedDomain

struct TimerListContentView: View {
    
    // MARK: - Constants
    
    private let entrySpacing: CGFloat = 8
    private let padding: CGFloat = 16
    private let wrapperSpacing: CGFloat = 0
    
    // MARK: - Stored properties
    
    @State private var fillerSize: CGFloat = .zero
    
    private let entries: [TimerEntryPreview]
    private let timerControlParams: TimerControlView.Params
    private let isLoading: Bool
    
    // MARK: - Init
    
    init(
        entries: [TimerEntryPreview],
        timerControlParams: TimerControlView.Params,
        isLoading: Bool
    ) {
        self.entries = entries
        self.timerControlParams = timerControlParams
        self.isLoading = isLoading
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: wrapperSpacing) {
                    Color.clear.frame(height: fillerSize)
                    
                    VStack(spacing: entrySpacing) {
                        ForEach(entries) { entry in
                            TimerEntryView(timerEntry: entry)
                                .skeleton(isLoading)
                        }
                        
                        TimerControlView(params: timerControlParams)
                            .skeleton(isLoading)
                            .animateContent(timerControlParams.data.data?.type)
                    }
                    .animateContent(isLoading)
                    .padding(padding)
                    .background(
                        GeometryReader { contentGeometry in
                            Color.clear
                                .onAppear {
                                    onGeometryChange(outer: geometry, content: contentGeometry)
                                }
                                .onChange(of: entries) {
                                    onGeometryChange(outer: geometry, content: contentGeometry)
                                }
                        }
                    )
                }
            }
            .defaultScrollAnchor(.bottom)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    // MARK: - Private
    
    private func onGeometryChange(outer: GeometryProxy, content: GeometryProxy) {
        guard content.size.height < outer.size.height else {
            fillerSize = 0
            return
        }
        fillerSize = outer.size.height - content.size.height
    }
}

#if DEBUG
import DependencyInjectionMocks

#Preview {
    TimerListContentView(
        entries: .stub,
        timerControlParams: TimerControlView.Params(
            data: .data(.stub),
            manualEnd: nil,
            formattedLength: "05:24:14",
            formattedInterval: TimerEntryInterval(
                start: TimerDataPreview.stub.startedAt?.asDate ?? .now,
                end: .now
            ),
            onProjectClick: {},
            onControlClick: {},
            onSwitchClick: {},
            onDeleteClick: {},
            onTimeEditClick: {},
            onDescriptionChange: { _ in }
        ),
        isLoading: false
    )
    .background(
        AppTheme.Colors.background
    )
}
#endif


