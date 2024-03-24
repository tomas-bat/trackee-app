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
            switch viewModel.state.viewData {
            case let .data(entries), let .loading(entries):
                TimerListContentView(
                    entries: entries,
                    isLoading: viewModel.state.viewData.isLoading
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
