//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit
import UIKit

enum TimerFlow: Flow, Equatable {
    case list(List)
    case projectSelection(ProjectSelection)
    case timeSelection(TimeSelection)
    
    enum List: Equatable {
        case showProjectSelection(
            delegate: ProjectSelectionViewModelDelegate?
        )
        
        case showTimeSelection(
            initialStart: Date?,
            initialEnd: Date?,
            delegate: TimeSelectionViewModelDelegate?
        )
        
        static func == (lhs: TimerFlow.List, rhs: TimerFlow.List) -> Bool {
            switch (lhs, rhs) {
            case (.showProjectSelection, .showProjectSelection): true
            case (.showTimeSelection, .showTimeSelection): true
            default: false
            }
        }
    }
    
    enum ProjectSelection: Equatable {
        case dismiss
    }
    
    enum TimeSelection: Equatable {
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
        guard let flow = flow as? TimerFlow else { return }
        switch flow {
        case let .list(flow): handleListFlow(flow)
        case let .projectSelection(flow): handleProjectSelectionFlow(flow)
        case let .timeSelection(flow): handleTimeSelectionFlow(flow)
        }
    }
}

// MARK: - List flow
extension TimerFlowController {
    func handleListFlow(_ flow: TimerFlow.List) {
        switch flow {
        case let .showProjectSelection(delegate): showProjectSelection(delegate: delegate)
        case let .showTimeSelection(start, end, delegate):
            showTimeSelection(
                initialStart: start,
                initialEnd: end,
                delegate: delegate
            )
        }
    }
    
    private func showProjectSelection(
        delegate: ProjectSelectionViewModelDelegate?
    ) {
        let vm = ProjectSelectionViewModel(flowController: self)
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
}

// MARK: - ProjectSelection flow
extension TimerFlowController {
    func handleProjectSelectionFlow(_ flow: TimerFlow.ProjectSelection) {
        switch flow {
        case .dismiss: navigationController.dismiss(animated: true)
        }
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
