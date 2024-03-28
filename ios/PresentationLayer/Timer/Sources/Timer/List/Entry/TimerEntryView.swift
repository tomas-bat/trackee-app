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
    
    private let wrapperSpacing: CGFloat = 0
    private let spacing: CGFloat = 8
    private let headerHorizontalSpacing: CGFloat = 4
    private let headerVerticalSpacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let timeIntervalStackSpacing: CGFloat = 1
    private let padding: CGFloat = 16
    private let cornerRadius: CGSize = CGFloat(8).squared
    private let trashSize: CGFloat = 24
    private let trashPadding: CGFloat = 14
    private let deleteTreshold: CGFloat = -100
    private let trashStrokeWidth: CGFloat = 4
    private let trashOffsetDenominator: CGFloat = 3
    
    // MARK: - Stored properties
    
    private let timerEntry: TimerEntryPreview
    private let deleteLoading: Bool
    private let canDelete: Bool
    private let onDelete: () -> Void
    
    @State private var dragOffset: CGFloat = .zero
    @State private var isAfterThreshold = false
    
    // MARK: - Init
    
    init(
        timerEntry: TimerEntryPreview,
        deleteLoading: Bool,
        canDelete: Bool,
        onDelete: @escaping () -> Void
    ) {
        self.timerEntry = timerEntry
        self.deleteLoading = deleteLoading
        self.canDelete = canDelete
        self.onDelete = onDelete
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(alignment: .top, spacing: headerHorizontalSpacing) {
                if let type = timerEntry.project.type {
                    type.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                }
                
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
        .offset(x: dragOffset)
        .background(alignment: .trailing) {
            deleteView
        }
        .multilineTextAlignment(.leading)
        .foregroundStyle(AppTheme.Colors.foreground)
        .sensoryFeedback(.impact, trigger: isAfterThreshold)
        .gesture(
            DragGesture()
                .onChanged(onGestureChange)
                .onEnded(onGestureEnd)
        )
        .onChange(of: deleteLoading) {
            if !deleteLoading {
                withAnimation {
                    dragOffset = 0
                }
            }
        }
    }
    
    // MARK: - Private
    
    private var trashOpacity: CGFloat {
        1 - dragOffset.normalize(min: -100, max: -50)
    }
    
    private var timerEntryInterval: TimerEntryInterval {
        TimerEntryInterval(
            start: timerEntry.startedAt.asDate,
            end: timerEntry.endedAt.asDate
        )
    }
    
    private var trashForegroundColor: Color {
        isAfterThreshold ? AppTheme.Colors.onDestructive : AppTheme.Colors.foreground
    }
    
    private var deleteView: some View {
        Group {
            if deleteLoading {
                ProgressView()
            } else {
                Image(systemSymbol: .trash)
                    .resizable()
                    .scaledToFit()
                    .frame(width: trashSize, height: trashSize)
                    .padding(trashPadding)
                    .foregroundStyle(trashForegroundColor)
                    .if(isAfterThreshold) { image in
                        image.background(
                            AppTheme.Colors.destructive
                        )
                    }
                    .if(!isAfterThreshold) { image in
                        image.background(
                            Circle()
                                .stroke(
                                    AppTheme.Colors.destructive,
                                    lineWidth: trashStrokeWidth
                                )
                        )
                    }
                    .clipShape(Circle())
                    .opacity(trashOpacity)
            }
        }
        .offset(x: dragOffset / trashOffsetDenominator)
    }
    
    private func onGestureChange(_ gesture: DragGesture.Value) {
        guard canDelete, !deleteLoading else { return }
        dragOffset = min(0, gesture.translation.width)
        isAfterThreshold = dragOffset < deleteTreshold
    }
    
    private func onGestureEnd(_ gesture: DragGesture.Value) {
        guard canDelete, !deleteLoading else { return }
        if isAfterThreshold {
            onDelete()
        } else {
            withAnimation {
                dragOffset = 0
            }
        }
    }
}

#if DEBUG
struct TimeEntryPreviewView: View {
    
    @State var isLoading = false
    
    var body: some View {
        TimerEntryView(
            timerEntry: .stub(),
            deleteLoading: isLoading,
            canDelete: true,
            onDelete: {
                isLoading = true
                _ = Task.delayed(byTimeInterval: 2) {
                    isLoading = false
                }
            }
        )
    }
}
#Preview {
    TimeEntryPreviewView()
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
}
#endif
