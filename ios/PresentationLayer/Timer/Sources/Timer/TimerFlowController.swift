//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit
import UIKit
import Profile

enum TimerFlow: Flow, Equatable {
    case list(List)
    case projectSelection(ProjectSelection)
    case timeSelection(TimeSelection)
    case startTimeSelection(StartTimeSelection)
    
    enum List: Equatable {
        case showProjectSelection(
            selectedProjectId: String?,
            delegate: ProjectSelectionViewModelDelegate?
        )
        
        case showTimeSelection(
            initialStart: Date?,
            initialEnd: Date?,
            delegate: TimeSelectionViewModelDelegate?
        )
        
        case showStartTimeSelection(
            initialStart: Date?,
            delegate: StartTimeSelectionViewModelDelegate?
        )
        
        case showDetail(
            entryId: String,
            delegate: TimerEntryDetailFlowControllerDelegate?
        )
        
        static func == (lhs: TimerFlow.List, rhs: TimerFlow.List) -> Bool {
            switch (lhs, rhs) {
            case (.showProjectSelection, .showProjectSelection): true
            case (.showTimeSelection, .showTimeSelection): true
            case (.showStartTimeSelection, .showStartTimeSelection): true
            case (.showDetail, .showDetail): true
            default: false
            }
        }
    }
    
    enum ProjectSelection: Equatable {
        case pop
        case dismiss
        case showNewProject(delegate: ProjectDetailViewModelDelegate?)
        case showNewClient(delegate: ClientDetailViewModelDelegate?)
        
        static func == (lhs: TimerFlow.ProjectSelection, rhs: TimerFlow.ProjectSelection) -> Bool {
            switch (lhs, rhs) {
            case (.pop, .pop), (.dismiss, .dismiss), (.showNewProject, .showNewProject),
                (.showNewClient, .showNewClient): true
            default: false
            }
        }
    }
    
    enum TimeSelection: Equatable {
        case dismiss
    }
    
    enum StartTimeSelection: Equatable {
        case dismiss
    }
}

public protocol TimerFlowControllerDelegate: AnyObject {
    
}

public final class TimerFlowController: FlowController {
    
    public weak var delegate: TimerFlowControllerDelegate?
    
    public override func setup() -> UIViewController {
        let vm = TimerListViewModel(flowController: self)
        let view = TimerListView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        switch flow {
        case let flow as TimerFlow:
            switch flow {
            case let .list(flow): handleListFlow(flow)
            case let .projectSelection(flow): handleProjectSelectionFlow(flow)
            case let .timeSelection(flow): handleTimeSelectionFlow(flow)
            case let .startTimeSelection(flow): handleStartTimeSelectionFlow(flow)
            }
        case let flow as ProfileFlow:
            switch flow {
            case let .clients(flow):
                switch flow {
                case .dismissModal: navigationController.dismiss(animated: true)
                default: return
                }
            default: return
            }
        default: return
        }
    }
}

// MARK: - List flow
extension TimerFlowController {
    func handleListFlow(_ flow: TimerFlow.List) {
        switch flow {
        case let .showProjectSelection(selectedProjectId, delegate):
            showProjectSelection(
                selectedProjectId: selectedProjectId,
                delegate: delegate
            )
        case let .showTimeSelection(start, end, delegate):
            showTimeSelection(
                initialStart: start,
                initialEnd: end,
                delegate: delegate
            )
        case let .showStartTimeSelection(initialStart, delegate):
            showStartTimeSelection(
                initialStart: initialStart,
                delegate: delegate
            )
        case let .showDetail(entryId, delegate):
            showDetail(
                entryId: entryId,
                delegate: delegate
            )
        }
    }
    
    private func showProjectSelection(
        selectedProjectId: String?,
        delegate: ProjectSelectionViewModelDelegate?
    ) {
        let vm = ProjectSelectionViewModel(
            selectedProjectId: selectedProjectId,
            isEmbedded: false,
            flowController: self
        )
        vm.delegate = delegate
        let view = ProjectSelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.present(vc, animated: true)
    }
    
    private func showTimeSelection(
        initialStart: Date?,
        initialEnd: Date?,
        delegate: TimeSelectionViewModelDelegate?
    ) {
        let vm = TimeSelectionViewModel(
            initialStart: initialStart,
            initialEnd: initialEnd,
            flowController: self
        )
        vm.delegate = delegate
        let view = TimeSelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.present(vc, animated: true)
    }
    
    private func showStartTimeSelection(
        initialStart: Date?,
        delegate: StartTimeSelectionViewModelDelegate?
    ) {
        let vm = StartTimeSelectionViewModel(
            initialStart: initialStart,
            flowController: self
        )
        vm.delegate = delegate
        let view = StartTimeSelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.present(vc, animated: true)
    }
    
    private func showDetail(
        entryId: String,
        delegate: TimerEntryDetailFlowControllerDelegate?
    ) {
        let nc = BaseNavigationController()
        let fc = TimerEntryDetailFlowController(
            entryId: entryId,
            navigationController: nc
        )
        fc.delegate = delegate
        let rootVc = startChildFlow(fc)
        nc.viewControllers = [rootVc]
        
        navigationController.present(nc, animated: true)
    }
}

// MARK: - ProjectSelection flow

extension TimerFlowController {
    func handleProjectSelectionFlow(_ flow: TimerFlow.ProjectSelection) {
        switch flow {
        case .pop: pop()
        case .dismiss: navigationController.dismiss(animated: true)
        case let .showNewProject(delegate): showNewProject(delegate: delegate)
        case let .showNewClient(delegate): showNewClient(delegate: delegate)
        }
    }
    
    private func showNewProject(delegate: ProjectDetailViewModelDelegate?) {
        let nc = BaseNavigationController()
        let fc = ProjectDetailFlowController(
            editingClientId: nil,
            editingProjectId: nil,
            delegate: delegate,
            navigationController: nc
        )
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        navigationController.presentedViewController?.present(nc, animated: true)
    }
    
    private func showNewClient(delegate: ClientDetailViewModelDelegate?) {
        let vm = ClientDetailViewModel(
            flowController: self
        )
        vm.delegate = delegate
        let view = ClientDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.presentedViewController?.present(vc, animated: true)
    }
}

// MARK: - TimeSelection flow

extension TimerFlowController {
    func handleTimeSelectionFlow(_ flow: TimerFlow.TimeSelection) {
        switch flow {
        case .dismiss: navigationController.dismiss(animated: true)
        }
    }
}

// MARK: - StartTimeSelection flow

extension TimerFlowController {
    func handleStartTimeSelectionFlow(_ flow: TimerFlow.StartTimeSelection) {
        switch flow {
        case .dismiss: navigationController.dismiss(animated: true)
        }
    }
}
