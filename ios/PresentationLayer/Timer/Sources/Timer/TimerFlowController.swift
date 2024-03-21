//
//  Created by Tomáš Batěk on 21.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit
import UIKit

enum TimerFlow: Flow, Equatable {
    case list(List)
    case detail(Detail)
    
    enum List: Equatable {
        
    }
    
    enum Detail: Equatable {
        
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
        case let .detail(flow): handleDetailFlow(flow)
        }
    }
}

// MARK: - List flow
extension TimerFlowController {
    func handleListFlow(_ flow: TimerFlow.List) {
        switch flow {
            
        }
    }
}

// MARK: - Detail flow
extension TimerFlowController {
    func handleDetailFlow(_ flow: TimerFlow.Detail) {
        switch flow {
            
        }
    }
}
