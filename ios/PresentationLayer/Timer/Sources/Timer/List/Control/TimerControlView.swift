//
//  Created by Tomáš Batěk on 24.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit
import SharedDomain

struct TimerControlView: View {
    
    struct Params {
        let data: ViewData<TimerDataPreview>
        let manualEnd: Date?
        let formattedLength: String?
        let formattedInterval: TimerEntryInterval?
        let controlLoading: Bool
        let switchLoading: Bool
        let discardLoading: Bool
        let onProjectClick: () -> Void
        let onControlClick: () -> Void
        let onSwitchClick: () -> Void
        let onDeleteClick: () -> Void
        let onStartEditClick: () -> Void
        let onTimeEditClick: () -> Void
        let onDescriptionSubmit: () -> Void
        let onDescriptionChange: (String?) -> Void
    }
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let selectorHorizontalSpacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let chevronSize: CGFloat = 14
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
    private let timeIntervalStackSpacing: CGFloat = 1
    private let timePadding: CGFloat = 8
    private let timeCornerRadius: CGFloat = 4
    private let selectorLineLimit: Int? = 1
    private let expandedSelectorLineLimit: Int? = nil
    private let overviewSpacing: CGFloat = 4
    private let chevronPadding: CGFloat = 4
    private let typeImageOffset: CGFloat = 2
    private let colorCircleSize: CGFloat = 10
    private let textFieldLineRange = 1...4
    
    // MARK: - Stored properties
    
    private let params: Params
    
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
    
    // MARK: - Init
    
    init(
        params: Params
    ) {
        self.params = params
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch params.data {
            case let .data(data), let .loading(data):
                VStack(alignment: .leading, spacing: spacing) {
                    projectSelector(data: data)
                    
                    descriptionView(data: data)
                    
                    controlView(data: data)
                }
                .skeleton(params.data.isLoading)
                .foregroundStyle(AppTheme.Colors.foreground)
                .padding(padding)
                .background(AppTheme.Colors.contentBackground)
                .clipShape(RoundedRectangle(cornerSize: cornerRadius.squared))
            case let .error(error):
                ErrorView(error: error)
            case .empty:
                EmptyView()
            }
        }
        .disabled(params.controlLoading || params.switchLoading || params.discardLoading)
    }
    
    // MARK: - Private
    
    private var chevron: some View {
        Image(systemSymbol: .chevronDown)
            .resizable()
            .scaledToFit()
            .frame(width: chevronSize)
            .padding(.vertical, chevronPadding)
    }
    
    private func projectSelector(data: TimerDataPreview) -> some View {
        Button(action: params.onProjectClick) {
            HStack(alignment: .firstTextBaseline, spacing: selectorHorizontalSpacing) {
                if let type = data.project?.type {
                    type.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .offset(y: typeImageOffset)
                }
                
                if let project = data.project, let client = data.client {
                    ZStack(alignment: .topLeading) {
                        horizontalProjectOverview(client: client, project: project)
                            .opacity(isTruncated ? 0 : 1)
                        
                        if isTruncated {
                            verticalProjectOverview(client: client, project: project)
                        }
                    }
                    
                } else {
                    Text(L10n.timer_view_select_project)
                        .italic()
                        .font(AppTheme.Fonts.headlineAdditional)
                        .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                    
                    chevron
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
    
    private func verticalProjectOverview(client: Client, project: Project) -> some View {
        VStack(alignment: .leading, spacing: overviewSpacing) {
            HStack(alignment: .firstTextBaseline, spacing: selectorHorizontalSpacing) {
                Text(project.name)
                    .font(AppTheme.Fonts.headline)
                
                if let color = project.color {
                    color.circle
                        .frame(width: colorCircleSize, height: colorCircleSize)
                }
                
                chevron
                    .offset(y: typeImageOffset)
            }
            
            Text(client.name)
                .font(AppTheme.Fonts.headlineAdditional)
                .foregroundStyle(AppTheme.Colors.foregroundSecondary)
        }
        .lineLimit(nil)
    }
    
    private func horizontalProjectOverview(client: Client, project: Project) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: selectorHorizontalSpacing) {
            TruncableText(
                text: Text(project.name),
                lineLimit: selectorLineLimit,
                isTruncatedUpdate: { projectTruncated = $0 }
            )
            .font(AppTheme.Fonts.headline)
            
            TruncableText(
                text: Text(client.name),
                lineLimit: selectorLineLimit,
                isTruncatedUpdate: { clientTruncated = $0 }
            )
            .font(AppTheme.Fonts.headlineAdditional)
            .foregroundStyle(AppTheme.Colors.foregroundSecondary)
            
            if let color = project.color {
                color.circle
                    .frame(width: colorCircleSize, height: colorCircleSize)
            }
            
            chevron
                .offset(y: typeImageOffset)
        }
    }
    
    private func descriptionView(data: TimerDataPreview) -> some View {
        TextField(
            L10n.timer_control_add_description_placeholder,
            text: Binding<String>(
                get: { data.description_ ?? "" },
                set: { description in params.onDescriptionChange(description) }
            ),
            axis: .vertical
        )
        .onSubmit {
            params.onDescriptionSubmit()
        }
        .textFieldStyle(.info)
        .lineLimit(textFieldLineRange)
        .font(AppTheme.Fonts.body)
        .submitLabel(.done)
    }
    
    private func controlView(data: TimerDataPreview) -> some View {
        HStack {
            // Time control
            HStack {
                Spacer()
                
                if data.type == .timer, data.status == .active, let length = params.formattedLength {
                    Button(action: params.onStartEditClick) {
                        Text(length)
                            .font(AppTheme.Fonts.headline)
                            .padding(timePadding)
                            .background(AppTheme.Colors.field)
                            .clipShape(RoundedRectangle(cornerSize: timeCornerRadius.squared))
                    }
                } else if data.type == .manual, let formattedInterval = params.formattedInterval {
                    Button(action: params.onTimeEditClick) {
                        HStack(alignment: .top, spacing: timeIntervalStackSpacing) {
                            Text(formattedInterval.localizedRange.time)
                            
                            if let extra = formattedInterval.localizedRange.extra {
                                Text(extra)
                                    .font(AppTheme.Fonts.index)
                            }
                        }
                        .padding(timePadding)
                        .background(AppTheme.Colors.field)
                        .clipShape(RoundedRectangle(cornerSize: timeCornerRadius.squared))
                    }
                    .font(AppTheme.Fonts.headline)
                }
                
                Spacer()
            }
            
            // Control buttons
            HStack(alignment: .center, spacing: 8) {
                if data.type == .timer, data.status == .active {
                    TimerControlButton(
                        type: .discard,
                        isLoading: params.discardLoading,
                        action: params.onDeleteClick
                    )
                    
                    TimerControlButton(
                        type: .stop,
                        isLoading: params.controlLoading,
                        isLarge: true,
                        action: params.onControlClick
                    )
                } else if data.type == .timer, data.status == .off {
                    TimerControlButton(
                        type: .add,
                        isLoading: params.switchLoading,
                        action: params.onSwitchClick
                    )
                    
                    TimerControlButton(
                        type: .start,
                        isLoading: params.controlLoading,
                        isLarge: true,
                        action: params.onControlClick
                    )
                } else if data.type == .manual {
                    TimerControlButton(
                        type: .timer,
                        isLoading: params.switchLoading,
                        action: params.onSwitchClick
                    )
                    
                    TimerControlButton(
                        type: .add,
                        isLoading: params.controlLoading,
                        isLarge: true,
                        action: params.onControlClick
                    )
                } else {
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
import DependencyInjectionMocks

struct TimerControlView_Previews: PreviewProvider {
    struct PreviewView: View {
        
        @State var timerData = TimerDataPreview.stub
        var length = "05:24:14"
        
        var body: some View {
            TimerControlView(
                params: TimerControlView.Params(
                    data: .data(timerData),
                    manualEnd: nil,
                    formattedLength: length,
                    formattedInterval: TimerEntryInterval(
                        start: timerData.startedAt?.asDate ?? .now,
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
                    onDescriptionChange: { description in
                        timerData = TimerDataPreview(
                            status: timerData.status,
                            type: timerData.type,
                            client: timerData.client,
                            project: timerData.project,
                            description: description,
                            startedAt: Date.now.asInstant
                        )
                    }
                )
            )
        }
    }
    
    static var previews: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Spacer()
                
                PreviewView(
                    timerData: .init(
                        status: .active,
                        type: .timer,
                        client: .init(
                            id: UUID().uuidString,
                            name: "Lorem ipsum dolor sit clientelos los mongos"
                        ),
                        project: .init(
                            id: UUID().uuidString,
                            clientId: UUID().uuidString,
                            type: .work,
                            name: "Dolor sit amet des uvales projecteles verimal",
                            color: ProjectColor.allCases.randomElement()
                        ),
                        description: "Vestibulum at iaculis risus. Donec facilisis non elit ut dignissim. Maecenas lobortis cursus fringilla.",
                        startedAt: Date(timeIntervalSinceNow: -5_000).asInstant
                    )
                )
                
                PreviewView()
                
                PreviewView(
                    timerData: TimerDataPreview(
                        status: .off,
                        type: .timer,
                        client: .stub(),
                        project: .stub(),
                        description: nil,
                        startedAt: nil
                    )
                )
                
                PreviewView(
                    timerData: TimerDataPreview(
                        status: .off,
                        type: .manual,
                        client: .stub(),
                        project: .stub(),
                        description: nil,
                        startedAt: nil
                    )
                )
                
                PreviewView(
                    timerData: TimerDataPreview(
                        status: .active,
                        type: .timer,
                        client: .stub(),
                        project: .stub(),
                        description: nil,
                        startedAt: Date(timeIntervalSinceNow: -5_000).asInstant
                    ),
                    length: "00:51:38"
                )
                
                PreviewView(
                    timerData: TimerDataPreview(
                        status: .off,
                        type: .timer,
                        client: nil,
                        project: nil,
                        description: nil,
                        startedAt: nil
                    )
                )
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(AppTheme.Colors.background)
    }
}
#endif
