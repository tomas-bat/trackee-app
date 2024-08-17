//
//  Created by Tomáš Batěk on 17.08.2024
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

final class TimerEntryDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.getTimerEntryUseCase) private var getTimerEntryUseCase
    @Injected(\.getProjectPreviewUseCase) private var getProjectPreviewUseCase
    
    // MARK: - Stored properties
    
    private let entryId: String
    
    // MARK: - Init
    
    init(
        entryId: String,
        flowController: FlowController? = nil
    ) {
        self.entryId = entryId
        self.flowController = flowController
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        if !state.entry.hasData {
            executeTask(Task {
                await fetch()
            })
        } else if !state.project.hasData {
            executeTask(Task {
                await fetchProject()
            })
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var entry: ViewData<TimerEntryPreview> = .loading(mock: .stub())
        var project: ViewData<ProjectPreview> = .loading(mock: .stub())
        var startDate = Date.now
        var endDate = Date.now
        var description = ""
    }
    
    // MARK: - Intent
    
    enum Intent {
        case retry
        case retryProject
        case selectProject
        case setStartDate(to: Date)
        case setEndDate(to: Date)
        case changeDescription(to: String)
        case save
        case cancel
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case .retry: await fetch()
            case .retryProject: await fetchProject()
            case .selectProject: ()
            case let .setStartDate(date): setStartDate(to: date)
            case let .setEndDate(date): setEndDate(to: date)
            case let .changeDescription(description): state.description = description
            case .save: ()
            case .cancel: ()
            }
        })
    }
    
    // MARK: - Private
    
    private func fetch() async {
        await fetchEntry()
        await fetchProject()
    }
    
    private func fetchEntry() async {
        if !state.entry.hasData {
            state.entry = .loading(mock: .stub())
        }
        
        do {
            let params = GetTimerEntryUseCaseParams(entryId: entryId)
            let entry: TimerEntryPreview = try await getTimerEntryUseCase.execute(params: params)
            state.entry = .data(entry)
            state.startDate = entry.startedAt.asDate
            state.endDate = entry.endedAt.asDate
        } catch {
            state.entry = .error(error)
        }
    }
    
    private func fetchProject() async {
        guard let data = state.entry.data else { return }
        
        if !state.project.hasData {
            state.project = .loading(mock: .stub())
        }
        do {
            let params = GetProjectPreviewUseCaseParams(
                clientId: data.client.id,
                projectId: data.project.id
            )
            let project: ProjectPreview = try await getProjectPreviewUseCase.execute(params: params)
            state.project = .data(project)
        } catch {
            state.project = .error(error)
        }
    }
    
    private func setStartDate(to date: Date) {
        state.startDate = date
    }
    
    private func setEndDate(to date: Date) {
        state.endDate = date
    }
}
