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
    
    enum List: Equatable {
        case showProjectSelection
    }
    
    enum ProjectSelection: Equatable {
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
        }
    }
}

// MARK: - List flow
extension TimerFlowController {
    func handleListFlow(_ flow: TimerFlow.List) {
        switch flow {
        case .showProjectSelection:
            let vm = ProjectSelectionViewModel(flowController: self)
            let view = ProjectSelectionView(viewModel: vm)
            let vc = BaseHostingController(rootView: view)
            
            navigationController.present(vc, animated: true)
        }
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
