//
//  Created by Tomáš Batěk on 17.08.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SharedDomain
import SwiftUI
import UIToolkit
import KMPSharedDomain
import Utilities

struct TimerEntryDetailView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let extraPadding: CGFloat = 8
    private let textFieldLineRange = 3...10
    private let integrationLogoSize: CGFloat = 16
    private let disabledOpacity: CGFloat = 0.5
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: TimerEntryDetailViewModel
    
    @FocusState private var textFieldFocused: Bool
    
    // MARK: - Init
    
    init(viewModel: TimerEntryDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.entry {
            case let .data(entry), let .loading(entry):
                ScrollView(showsIndicators: false) {
                    VStack(spacing: spacing) {
                        projectView(for: entry)
                        
                        timeView(
                            for: entry,
                            isLoading: viewModel.state.entry.isLoading
                        )
                        
                        descriptionView
                    }
                    .padding(padding)
                }
                .skeleton(viewModel.state.entry.isLoading)
            case let .error(error):
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.async(.retry)) }
                )
                .padding(padding)
            case .empty: EmptyView()
            }
        }
        .foregroundStyle(AppTheme.Colors.foreground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animateContent(viewModel.state.entry.isLoading)
        .animateContent(viewModel.state.project.isLoading)
        .navigationTitle(L10n.timer_entry_detail_view_title)
        .toolbar(.visible)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.save_label) {
                    viewModel.onIntent(.async(.save))
                }
                .buttonStyle(.loading)
                .environment(\.isLoading, viewModel.state.saveLoading)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(L10n.cancel) {
                    viewModel.onIntent(.sync(.cancel))
                }
            }
        }
        .disabled(viewModel.state.saveLoading)
        .interactiveDismissDisabled()
        .toolbarTitleDisplayMode(.inline)
        .background(AppTheme.Colors.background)
        .snack(viewModel.snackState)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private func projectView(for entry: TimerEntryPreview) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            Button {
                viewModel.onIntent(.sync(.selectProject))
            } label: {
                switch viewModel.state.project {
                case let .data(project), let .loading(mock: project):
                    TimerEntryProjectView(project: project)
                        .skeleton(viewModel.state.project.isLoading)
                case let .error(error):
                    ErrorView(
                        error: error,
                        onRetryTap: { viewModel.onIntent(.async(.retryProject)) }
                    )
                case .empty: EmptyView()
                }
            }
            .disabled(!viewModel.state.canEditProject)
            .opacity(viewModel.state.canEditProject ? 1 : disabledOpacity)
            
            if entry.hasClockifyConnection {
                HStack(alignment: .center, spacing: spacing) {
                    Asset.Images.clockifyLogo.image
                        .resizable()
                        .frame(width: integrationLogoSize, height: integrationLogoSize)
                    
                    Text(L10n.timer_entry_detail_view_clockify_cannot_edit_project)
                        .font(AppTheme.Fonts.detail)
                        .italic()
                }
                .padding(.horizontal, extraPadding)
            }
        }
    }
    
    private func formattedDuration(for entry: TimerEntryPreview) -> String? {
        if viewModel.state.endDate < viewModel.state.startDate { return "" }
        let formatter = Formatter.DateComponents.default
        return formatter.string(
            from: viewModel.state.startDate,
            to: viewModel.state.endDate
        )
    }
    
    private func timeView(
        for entry: TimerEntryPreview,
        isLoading: Bool
    ) -> some View {
        VStack(spacing: spacing) {
            timeRow(
                label: L10n.timer_entry_detail_view_start_time_label,
                isLoading: isLoading,
                date: Binding<Date>(
                    get: { viewModel.state.startDate },
                    set: { date in viewModel.onIntent(.sync(.setStartDate(to: date))) }
                )
            )
            .padding(.leading, extraPadding)
            
            timeRow(
                label: L10n.timer_entry_detail_view_end_time_label,
                isLoading: isLoading,
                date: Binding<Date>(
                    get: { viewModel.state.endDate },
                    set: { date in viewModel.onIntent(.sync(.setEndDate(to: date))) }
                )
            )
            .padding(.leading, extraPadding)
            
            if let duration = formattedDuration(for: entry) {
                HStack(spacing: spacing) {
                    Text(L10n.timer_entry_detail_view_duration_label)
                        .font(AppTheme.Fonts.headline)
                    
                    Spacer()
                    
                    Text(duration)
                        .font(AppTheme.Fonts.headlineAdditional)
                }
                .padding(extraPadding)
            }
        }
        .padding(extraPadding)
        .background(AppTheme.Colors.contentBackground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private func timeRow(
        label: String,
        isLoading: Bool,
        date: Binding<Date>
    ) -> some View {
        HStack(spacing: spacing) {
            Text(label)
                .font(AppTheme.Fonts.headline)
            
            Spacer()
            
            if !isLoading {
                DatePicker(
                    "",
                    selection: date,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(L10n.timer_entry_detail_view_description_label)
                .font(AppTheme.Fonts.headline)
            
            TextField(
                L10n.timer_control_add_description_placeholder,
                text: Binding<String>(
                    get: { viewModel.state.description },
                    set: { description in
                        if description == viewModel.state.description + "\n" {
                            textFieldFocused = false
                        } else {
                            viewModel.onIntent(.sync(.changeDescription(to: description)))
                        }
                    }
                ),
                axis: .vertical
            )
            .lineLimit(textFieldLineRange)
            .textFieldStyle(.info)
            .focused($textFieldFocused)
            .font(AppTheme.Fonts.body)
            .submitLabel(.done)
        }
        .padding(padding)
        .background(AppTheme.Colors.contentBackground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
}


#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = TimerEntryDetailViewModel(entryId: "entry_id")
    return Text("Base View")
        .sheet(isPresented: .constant(true)) {
            NavigationView {
                TimerEntryDetailView(viewModel: vm)
            }
        }
}
#endif

