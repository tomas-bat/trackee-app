//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain
import SharedDomainMocks

final class TimerListViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getTimerEntriesUseCase) private var getTimerEntriesUseCase
    @Injected(\.getTimerSummariesUseCase) private var getTimerSummariesUseCase
    
    // MARK: - Stored properties
    
    // MARK: - Init
    
    init(flowController: FlowController? = nil) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task { await fetchData() })
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var summaryViewData: ViewData<[TimerSummary]> = .loading(mock: .stub.reversed())
        var viewData: ViewData<[TimerEntryPreview]> = .loading(mock: .stub.reversed())
    }
    
    // MARK: - Intent
    
    enum Intent {
        case tryAgain
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .tryAgain: await fetchData()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetchData() async {
        guard !state.viewData.hasData || !state.summaryViewData.hasData else { return }
        
        state.viewData = .loading(mock: .stub)
        state.summaryViewData = .loading(mock: .stub)
        
        do {
            let entries: [TimerEntryPreview] = try await getTimerEntriesUseCase.execute()
            let summaries: [TimerSummary] = try await getTimerSummariesUseCase.execute()
            
            state.viewData = .data(entries)
            state.summaryViewData = .data(summaries)
        } catch {
            state.viewData = .error(error)
            state.summaryViewData = .empty
        }
    }
}
