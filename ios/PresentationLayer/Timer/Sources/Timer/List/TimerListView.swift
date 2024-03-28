//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct TimerListView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: TimerListViewModel
    
    // MARK: - Init
    
    init(viewModel: TimerListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.listData {
            case let .data(entries), let .loading(entries):
                TimerListContentView(
                    entries: entries,
                    timerControlParams: TimerControlView.Params(
                        data: viewModel.state.timerData,
                        manualEnd: viewModel.state.manualTimerEnd,
                        formattedLength: viewModel.state.formattedLength,
                        formattedInterval: viewModel.state.formattedInterval,
                        controlLoading: viewModel.state.controlLoading,
                        switchLoading: viewModel.state.switchLoading,
                        discardLoading: viewModel.state.discardLoading,
                        onProjectClick: { viewModel.onIntent(.onProjectClick) },
                        onControlClick: { viewModel.onIntent(.onControlClick) },
                        onSwitchClick: { viewModel.onIntent(.onSwitchClick) },
                        onDeleteClick: { viewModel.onIntent(.onDeleteClick) },
                        onTimeEditClick: { viewModel.onIntent(.onTimeEditClick) },
                        onDescriptionSubmit: { viewModel.onIntent(.onDescriptionSubmit) },
                        onDescriptionChange: { description in viewModel.onIntent(.onDescriptionChange(description)) }
                    ),
                    isLoading: viewModel.state.listData.isLoading
                )
            case let .error(error):
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.tryAgain) }
                )
                .padding(padding)
            case .empty:
                EmptyContentView(
                    text: L10n.timer_no_entries_title
                )
                .padding(padding)
                .buttonStyle(.bordered)
            }
        }
        .background(AppTheme.Colors.background)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                switch viewModel.state.summaryViewData {
                case let .data(summaries), let .loading(summaries):
                    TimerSummaryView(summaries: summaries)
                        .skeleton(viewModel.state.summaryViewData.isLoading)
                default: EmptyView()
                }
            }
        }
        .snack(viewModel.snackState)
        .lifecycle(viewModel)
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = TimerListViewModel()
    return NavigationView {
        TimerListView(viewModel: vm)
    }
}
#endif
