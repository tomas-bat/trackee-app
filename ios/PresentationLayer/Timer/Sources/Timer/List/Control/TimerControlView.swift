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
        let onProjectClick: () -> Void
        let onControlClick: () -> Void
        let onSwitchClick: () -> Void
        let onDeleteClick: () -> Void
        let onTimeEditClick: () -> Void
        let onDescriptionChange: (String?) -> Void
    }
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let selectorHorizontalSpacing: CGFloat = 4
    private let imageSize: CGFloat = 17
    private let chevronSize: CGFloat = 14
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let smallControlImageSize: CGFloat = 24
    private let largeControlImageSize: CGFloat = 26
    private let smallButtonSize: CGFloat = 50
    private let largeButtonSize: CGFloat = 62
    private let displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
    private let timeIntervalStackSpacing: CGFloat = 1
    private let timePadding: CGFloat = 8
    private let timeCornerRadius: CGFloat = 4
    
    // MARK: - Stored properties
    
    private let params: Params
    
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
    }
    
    // MARK: - Private
    
    private func projectSelector(data: TimerDataPreview) -> some View {
        Button(action: params.onProjectClick) {
            HStack(spacing: selectorHorizontalSpacing) {
                if let client = data.client, let project = data.project {
                    if let type = project.type {
                        type.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
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
    
    private func descriptionView(data: TimerDataPreview) -> some View {
        TextField(
            L10n.timer_control_add_description_placeholder,
            text: Binding<String>(
                get: { data.description_ ?? "" },
                set: { description in params.onDescriptionChange(description) }
            )
        )
        .textFieldStyle(.info)
        .font(AppTheme.Fonts.body)
        .submitLabel(.done)
    }
    
    private func controlView(data: TimerDataPreview) -> some View {
        HStack {
            // Time control
            HStack {
                Spacer()
                
                if data.type == .timer, data.status == .active, let length = params.formattedLength {
                    Text(length)
                        .font(AppTheme.Fonts.headline)
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
                    styledButton(
                        image: Image(systemSymbol: .trash),
                        action: params.onDeleteClick
                    )
                    
                    styledButton(
                        image: Image(systemSymbol: .stopFill),
                        isLarge: true,
                        action: params.onControlClick
                    )
                } else if data.type == .timer, data.status == .off {
                    styledButton(
                        image: Image(systemSymbol: .plus),
                        action: params.onSwitchClick
                    )
                    
                    styledButton(
                        image: Image(systemSymbol: .playFill),
                        isLarge: true,
                        action: params.onControlClick
                    )
                } else if data.type == .manual {
                    styledButton(
                        image: Image(systemSymbol: .timer),
                        action: params.onSwitchClick
                    )
                    
                    styledButton(
                        image: Image(systemSymbol: .plus),
                        isLarge: true,
                        action: params.onControlClick
                    )
                } else {
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func styledButton(
        image: Image,
        isLarge: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        let imageSize = isLarge ? largeControlImageSize : smallControlImageSize
        let buttonSize = isLarge ? largeButtonSize : smallButtonSize
        
        Button(action: action) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .frame(width: buttonSize, height: buttonSize)
                .background(AppTheme.Colors.field)
                .clipShape(Circle())
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
                    onProjectClick: {},
                    onControlClick: {},
                    onSwitchClick: {},
                    onDeleteClick: {},
                    onTimeEditClick: {},
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
        VStack {
            Spacer()
            
            PreviewView()
                .padding(.horizontal)
            
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
            .padding(.horizontal)
            
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
            .padding(.horizontal)
            
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
            .padding(.horizontal)
            
            Spacer()
        }
        .background(AppTheme.Colors.background)
    }
}
#endif
