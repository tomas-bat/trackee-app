//
//  Created by Tomáš Batěk on 19/04/2024.
//  Copyright © 2019 Matee. All rights reserved.
//

import SwiftUI
import UIKit
import UIToolkit

enum IntegrationsFlow: Flow, Equatable {
    case overview(Overview)
    
    enum Overview: Equatable {
        case showIntegrationDetail(integrationId: String)
        case showNewIntegration
    }
}

public final class IntegrationsFlowController: FlowController {
    
    public override func setup() -> UIViewController {
        let vm = IntegrationsOverviewViewModel(flowController: self)
        let view = IntegrationsOverviewView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? IntegrationsFlow else { return }
        switch flow {
        case let .overview(flow): handleOverviewFlow(flow)
        }
    }
}

// MARK: Overview flow
extension IntegrationsFlowController {
    func handleOverviewFlow(_ flow: IntegrationsFlow.Overview) {
        switch flow {
        case let .showIntegrationDetail(integrationId): showIntegrationDetail(integrationId: integrationId)
        case .showNewIntegration: showNewIntegration()
        }
    }
    
    private func showIntegrationDetail(integrationId: String) {
        
    }
    
    private func showNewIntegration() {
        
    }
}
