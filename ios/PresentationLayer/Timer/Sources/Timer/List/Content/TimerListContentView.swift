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
    
    private let entryGroupSpacing: CGFloat = 16
    private let groupTitleTopPadding: CGFloat = 16
    private let groupTitleBottomPadding: CGFloat = 8
    private let entrySpacing: CGFloat = 8
    private let padding: CGFloat = 16
    private let wrapperSpacing: CGFloat = 0
    
    // MARK: - Stored properties
    
    @State private var fillerSize: CGFloat = .zero
    
    private let groups: [TimerEntryGroup]
    private let timerControlParams: TimerControlView.Params
    private let onEntryDelete: (String) -> Void
    private let onEntryContinue: (String) -> Void
    private let onEntryCopyDescription: (String) -> Void
    private let deletingEntryId: String?
    private let isLoading: Bool
    private let canLoadMoreData: Bool
    private let isFetchingMore: Bool
    private let onFetchMore: () -> Void
    
    // MARK: - Init
    
    init(
        groups: [TimerEntryGroup],
        timerControlParams: TimerControlView.Params,
        isLoading: Bool,
        canLoadMoreData: Bool,
        isFetchingMore: Bool,
        deletingEntryId: String?,
        onEntryDelete: @escaping (String) -> Void,
        onEntryContinue: @escaping (String) -> Void,
        onEntryCopyDescription: @escaping (String) -> Void,
        onFetchMore: @escaping () -> Void
    ) {
        self.groups = groups
        self.timerControlParams = timerControlParams
        self.isLoading = isLoading
        self.canLoadMoreData = canLoadMoreData
        self.isFetchingMore = isFetchingMore
        self.deletingEntryId = deletingEntryId
        self.onEntryDelete = onEntryDelete
        self.onEntryContinue = onEntryContinue
        self.onEntryCopyDescription = onEntryCopyDescription
        self.onFetchMore = onFetchMore
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: wrapperSpacing) {
                    Color.clear.frame(height: fillerSize)
                    
                    LazyVStack(alignment: .leading, spacing: entrySpacing) {
                        if canLoadMoreData {
                            Button(L10n.fetch_more, action: onFetchMore)
                                .buttonStyle(.fetchMore)
                                .environment(\.isLoading, isFetchingMore)
                                .padding(padding)
                        }
                        
                        ForEach(0..<groups.count, id: \.self) { idx in
                            let group = groups[idx]
                            
                            if group.isFullyLoaded {
                                HStack {
                                    Text(group.date.asDate.localizedDate)
                                        .font(AppTheme.Fonts.title)
                                    
                                    Spacer()
                                    
                                    if let interval = group.formattedInterval {
                                        Text(interval)
                                            .font(AppTheme.Fonts.subtitle)
                                    }
                                }
                                .foregroundStyle(AppTheme.Colors.foreground)
                                .padding(.top, groupTitleTopPadding)
                                .padding(.bottom, groupTitleBottomPadding)
                                .animation(nil, value: UUID())
                            }
                            
                            ForEach(0..<group.entries.count, id: \.self) { idx in
                                let entry = group.entries[idx]
                                
                                TimerEntryView(
                                    timerEntry: entry,
                                    deleteLoading: deletingEntryId == entry.id,
                                    canDelete: deletingEntryId == nil,
                                    onDelete: { onEntryDelete(entry.id) },
                                    onContinue: { onEntryContinue(entry.id) },
                                    onCopyDescription: { onEntryCopyDescription(entry.id) }
                                )
                                .skeleton(isLoading)
                            }
                        }
                        
                        TimerControlView(params: timerControlParams)
                            .skeleton(isLoading)
                            .animateContent(timerControlParams.data.data?.type)
                    }
                    .animateContent(isLoading)
                    .padding(padding)
                    .readSize { size in
                        onGeometryChange(outer: geometry.size, content: size)
                    }
                }
            }
            .defaultScrollAnchor(.bottom)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    // MARK: - Private
    
    private func onGeometryChange(outer: CGSize, content: CGSize) {
        guard content.height < outer.height else {
            fillerSize = 0
            return
        }
        fillerSize = outer.height - content.height
    }
}

#if DEBUG
import DependencyInjectionMocks

#Preview {
    TimerListContentView(
        groups: .stub,
        timerControlParams: TimerControlView.Params(
            data: .data(.stub),
            manualEnd: nil,
            formattedLength: "05:24:14",
            formattedInterval: TimerEntryInterval(
                start: TimerDataPreview.stub.startedAt?.asDate ?? .now,
                end: .now
            ),
            controlLoading: false,
            switchLoading: false,
            discardLoading: false,
            onProjectClick: {},
            onControlClick: {},
            onSwitchClick: {},
            onDeleteClick: {},
            onStartEditClick: {},
            onTimeEditClick: {},
            onDescriptionSubmit: {},
            onDescriptionChange: { _ in }
        ),
        isLoading: false,
        canLoadMoreData: true,
        isFetchingMore: false,
        deletingEntryId: nil,
        onEntryDelete: { _ in },
        onEntryContinue: { _ in },
        onEntryCopyDescription: { _ in },
        onFetchMore: {}
    )
    .background(
        AppTheme.Colors.background
    )
}
#endif


