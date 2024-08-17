//
//  Created by Tomáš Batěk on 17.08.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SharedDomain
import SwiftUI
import UIToolkit
import KMPSharedDomain

struct TimerEntryDetailView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 8
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 8
    private let extraPadding: CGFloat = 8
    private let textFieldLineRange = 3...10
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: TimerEntryDetailViewModel
    
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
                        projectView
                        
                        timeView(for: entry)
                        
                        descriptionView
                    }
                    .padding(padding)
                }
                .skeleton(viewModel.state.entry.isLoading)
            case let .error(error):
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.retry) }
                )
                .padding(padding)
            case .empty: EmptyView()
            }
        }
        .foregroundStyle(AppTheme.Colors.foreground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animateContent(viewModel.state.entry.isLoading)
        .navigationTitle(L10n.timer_entry_detail_view_title)
        .toolbar(.visible)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.save_label) {
                    viewModel.onIntent(.save)
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(L10n.cancel) {
                    viewModel.onIntent(.cancel)
                }
            }
        }
        .interactiveDismissDisabled()
        .toolbarTitleDisplayMode(.inline)
        .background(AppTheme.Colors.background)
        .snack(viewModel.snackState)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private var projectView: some View {
        Button {
            viewModel.onIntent(.selectProject)
        } label: {
            switch viewModel.state.project {
            case let .data(project), let .loading(mock: project):
                TimerEntryProjectView(project: project)
                    .skeleton(viewModel.state.project.isLoading)
            case let .error(error):
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.retryProject) }
                )
            case .empty: EmptyView()
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
    
    private func timeView(for entry: TimerEntryPreview) -> some View {
        VStack(spacing: spacing) {
            timeRow(
                label: L10n.timer_entry_detail_view_start_time_label,
                date: Binding<Date>(
                    get: { viewModel.state.startDate },
                    set: { date in viewModel.onIntent(.setStartDate(to: date)) }
                )
            )
            .padding(.leading, extraPadding)
            
            timeRow(
                label: L10n.timer_entry_detail_view_end_time_label,
                date: Binding<Date>(
                    get: { viewModel.state.endDate },
                    set: { date in viewModel.onIntent(.setEndDate(to: date)) }
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
    
    private func timeRow(label: String, date: Binding<Date>) -> some View {
        HStack(spacing: spacing) {
            Text(label)
                .font(AppTheme.Fonts.headline)
            
            Spacer()
            
            DatePicker(
                "",
                selection: date,
                displayedComponents: [.date, .hourAndMinute]
            )
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
                    set: { description in viewModel.onIntent(.changeDescription(to: description)) }
                ),
                axis: .vertical
            )
            .lineLimit(textFieldLineRange)
            .textFieldStyle(.info)
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

