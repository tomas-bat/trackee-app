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
            case let .data(groups), let .loading(groups):
                TimerListContentView(
                    groups: groups,
                    timerControlParams: TimerControlView.Params(
                        data: viewModel.state.timerData,
                        manualEnd: viewModel.state.manualTimerEnd,
                        formattedLength: viewModel.state.formattedLength,
                        formattedInterval: viewModel.state.formattedInterval,
                        controlLoading: viewModel.state.controlLoading,
                        switchLoading: viewModel.state.switchLoading,
                        discardLoading: viewModel.state.discardLoading,
                        onProjectClick: { viewModel.onIntent(.sync(.onProjectClick)) },
                        onControlClick: { viewModel.onIntent(.async(.onControlClick)) },
                        onSwitchClick: { viewModel.onIntent(.async(.onSwitchClick)) },
                        onDeleteClick: { viewModel.onIntent(.async(.onDeleteClick)) },
                        onStartEditClick: { viewModel.onIntent(.sync(.onStartEditClick)) },
                        onTimeEditClick: { viewModel.onIntent(.sync(.onTimeEditClick)) },
                        onDescriptionSubmit: { viewModel.onIntent(.async(.onDescriptionSubmit)) },
                        onDescriptionChange: { description in
                            viewModel.onIntent(.sync(.onDescriptionChange(description)))
                        }
                    ),
                    isLoading: viewModel.state.listData.isLoading,
                    canLoadMoreData: viewModel.state.canLoadMoreData,
                    isFetchingMore: viewModel.state.isFetchingMore,
                    deletingEntryId: viewModel.state.deletingEntryId,
                    onEntryDelete: { id in viewModel.onIntent(.sync(.onEntryDelete(id: id))) },
                    onEntryContinue: { id in viewModel.onIntent(.async(.onEntryContinue(id: id))) },
                    onEntryCopyDescription: { id in viewModel.onIntent(.sync(.onEntryCopyDescription(id: id))) },
                    onEntryEdit: { id in viewModel.onIntent(.sync(.onEntryEdit(id: id))) },
                    onFetchMore: { viewModel.onIntent(.async(.onFetchMore)) }
                )
            case let .error(error):
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.async(.tryAgain)) }
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
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { data in viewModel.onIntent(.sync(.changeAlertData(to: data))) }
        )) { data in .init(data) }
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
