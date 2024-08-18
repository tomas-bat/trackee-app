//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import KMPSharedDomain
import UIToolkit
import SharedDomain
import SFSafeSymbols

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
    private let headerLineLimit: Int? = 1
    private let typeImageOffset: CGFloat = 2
    private let colorCircleSize: CGFloat = 10
    private let entryMenuSize: CGFloat = 24
    private let entryMenuOffset: CGFloat = -16
    private let markImageSize: CGFloat = 16
    
    // MARK: - Stored properties
    
    private let timerEntry: TimerEntryPreview
    private let deleteLoading: Bool
    private let canDelete: Bool
    private let onDelete: () -> Void
    private let onContinue: () -> Void
    private let onCopyDescription: () -> Void
    private let onEdit: () -> Void
    
    @State private var dragOffset: CGFloat = .zero
    @State private var isAfterThreshold = false
    @State private var fixTask: Task<Void, Error>?
    @State private var isTruncated = false
    
    @State private var clientTruncated = false {
        didSet {
            isTruncated = clientTruncated || projectTruncated
        }
    }
    
    @State private var projectTruncated = false {
        didSet {
            isTruncated = clientTruncated || projectTruncated
        }
    }
    
    @Environment(\.geometry) private var geometry
    
    // MARK: - Init
    
    init(
        timerEntry: TimerEntryPreview,
        deleteLoading: Bool,
        canDelete: Bool,
        onDelete: @escaping () -> Void,
        onContinue: @escaping () -> Void,
        onCopyDescription: @escaping () -> Void,
        onEdit: @escaping () -> Void
    ) {
        self.timerEntry = timerEntry
        self.deleteLoading = deleteLoading
        self.canDelete = canDelete
        self.onDelete = onDelete
        self.onContinue = onContinue
        self.onCopyDescription = onCopyDescription
        self.onEdit = onEdit
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(alignment: .firstTextBaseline, spacing: headerHorizontalSpacing) {
                if let type = timerEntry.project.type {
                    type.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .offset(y: typeImageOffset)
                }
                
                ZStack(alignment: .topLeading) {
                    horizontalProjectOverview(
                        client: timerEntry.client,
                        project: timerEntry.project
                    )
                    .opacity(isTruncated ? 0 : 1)
                    
                    if isTruncated {
                        verticalProjectOverview(
                            client: timerEntry.client,
                            project: timerEntry.project
                        )
                    }
                }
                
                Spacer()
             
                menu
            }
            
            if let description = timerEntry.description_ {
                Text(description)
                    .font(AppTheme.Fonts.body)
            }
            
            HStack(spacing: spacing) {
                HStack(alignment: .top, spacing: timeIntervalStackSpacing) {
                    Text(timerEntryInterval.localizedRange.time)
                    
                    if let extra = timerEntryInterval.localizedRange.extra {
                        Text(extra)
                            .font(AppTheme.Fonts.index)
                    }
                }
                
                if timerEntry.hasClockifyConnection {
                    Asset.Images.clockifyLogo.image
                        .resizable()
                        .frame(width: markImageSize, height: markImageSize)
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
            fixTask?.cancel()
            if deleteLoading {
                withAnimation {
                    dragOffset = -(4.0 / 3.0) * (geometry?.size.width ?? 0)
                }
            } else {
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
    
    private var menu: some View {
        Menu {
            Section {
                menuButton(
                    title: L10n.timer_view_continue_entry,
                    symbol: .playFill,
                    action: onContinue
                )
                
                menuButton(
                    title: L10n.timer_view_copy_entry_description,
                    symbol: .docOnDoc,
                    action: onCopyDescription
                )
                
                menuButton(
                    title: L10n.timer_view_entry_edit,
                    symbol: .pencil,
                    action: onEdit
                )
            }
            
            Section {
                menuButton(
                    title: L10n.timer_view_entry_delete,
                    symbol: .trash,
                    role: .destructive,
                    action: onDelete
                )
            }
        } label: {
            Asset.Images.entryOptions.image
                .resizable()
                .frame(width: entryMenuSize, height: entryMenuSize)
        }
        .frame(height: .zero) // Menu has weird layout
        .offset(y: entryMenuOffset)
    }
    
    private func menuButton(
        title: String,
        symbol: SFSymbol,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role, action: action) {
            HStack {
                Text(title)
                
                Image(systemSymbol: symbol)
            }
        }
    }
    
    @MainActor 
    private func onGestureChange(_ gesture: DragGesture.Value) {
        guard canDelete, !deleteLoading else { return }
        dragOffset = min(0, gesture.translation.width)
        isAfterThreshold = dragOffset < deleteTreshold
        
        fixTask?.cancel()
        fixTask = Task.delayed(byTimeInterval: 3) {
            guard !Task.isCancelled, !deleteLoading else { return }
            withAnimation {
                dragOffset = 0
            }
        }
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
    
    private func verticalProjectOverview(client: Client, project: Project) -> some View {
        VStack(alignment: .leading, spacing: headerVerticalSpacing) {
            HStack(alignment: .firstTextBaseline, spacing: headerHorizontalSpacing) {
                Text(project.name)
                    .font(AppTheme.Fonts.headline)
                
                if let color = timerEntry.project.color {
                    color.circle
                        .frame(width: colorCircleSize, height: colorCircleSize)
                }
            }
            
            Text(client.name)
                .font(AppTheme.Fonts.headlineAdditional)
                .foregroundStyle(AppTheme.Colors.foregroundSecondary)
        }
        .lineLimit(nil)
    }
    
    private func horizontalProjectOverview(client: Client, project: Project) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: headerHorizontalSpacing) {
            TruncableText(
                text: Text(project.name),
                lineLimit: headerLineLimit,
                isTruncatedUpdate: { projectTruncated = $0 }
            )
            .font(AppTheme.Fonts.headline)
            
            TruncableText(
                text: Text(client.name),
                lineLimit: headerLineLimit,
                isTruncatedUpdate: { clientTruncated = $0 }
            )
            .font(AppTheme.Fonts.headlineAdditional)
            .foregroundStyle(AppTheme.Colors.foregroundSecondary)
            
            if let color = project.color {
                color.circle
                    .frame(width: colorCircleSize, height: colorCircleSize)
            }
        }
    }
}

#if DEBUG
struct TimeEntryPreviewView: View {
    
    @State var isLoading = false
    
    var body: some View {
        VStack(spacing: 8) {
            TimerEntryView(
                timerEntry: .stub(),
                deleteLoading: isLoading,
                canDelete: true,
                onDelete: {
                    isLoading = true
                    _ = Task.delayed(byTimeInterval: 2) {
                        isLoading = false
                    }
                },
                onContinue: {},
                onCopyDescription: {},
                onEdit: {}
            )
            
            TimerEntryView(
                timerEntry: .stub(
                    project: Project(
                        id: .randomString(),
                        clientId: .randomString(),
                        type: .work,
                        name: "Unitersting extravagant projectelus mongeus",
                        color: .blue
                    ),
                    client: Client(
                        id: .randomString(),
                        name: "Unextraordinary individual company"
                    )
                ),
                deleteLoading: isLoading,
                canDelete: true,
                onDelete: {},
                onContinue: {},
                onCopyDescription: {},
                onEdit: {}
            )
        }
    }
}
#Preview {
    TimeEntryPreviewView()
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
}
#endif
