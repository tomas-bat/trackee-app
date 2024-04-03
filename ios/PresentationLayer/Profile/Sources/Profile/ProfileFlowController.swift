//
//  Created by Petr Chmelar on 06/02/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import SwiftUI
import UIKit
import UIToolkit

enum ProfileFlow: Flow, Equatable {
    case overview(Overview)
    case clients(Clients)
    case projects(Projects)
    
    enum Overview: Equatable {
        case presentOnboarding
        case showClients
        case showProjects
    }
    
    enum Clients: Equatable {
        case showDetail
        case showNewClient
    }
    
    enum Projects: Equatable {
        case showDetail
        case showNewProject
    }
}

public protocol ProfileFlowControllerDelegate: AnyObject {
    func presentOnboarding()
}

public final class ProfileFlowController: FlowController {
    
    public weak var delegate: ProfileFlowControllerDelegate?
    
    override public func setup() -> UIViewController {
        let vm = ProfileViewModel(flowController: self)
        return BaseHostingController(rootView: ProfileView(viewModel: vm))
    }
    
    override public func handleFlow(_ flow: Flow) {
        guard let profileFlow = flow as? ProfileFlow else { return }
        switch profileFlow {
        case let .overview(flow): handleOverviewFlow(flow)
        case let .clients(flow): handleClientsFlow(flow)
        case let .projects(flow): handleProjectsFlow(flow)
        }
    }
}

// MARK: Overview flow
extension ProfileFlowController {
    func handleOverviewFlow(_ flow: ProfileFlow.Overview) {
        switch flow {
        case .presentOnboarding: presentOnboarding()
        case .showClients: showClients()
        case .showProjects: showProjects()
        }
    }
    
    private func presentOnboarding() {
        delegate?.presentOnboarding()
    }
    
    private func showClients() {
        let vm = ClientsViewModel(flowController: self)
        let view = ClientsView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showProjects() {
        
    }
}

// MARK: Clients flow
extension ProfileFlowController {
    func handleClientsFlow(_ flow: ProfileFlow.Clients) {
        switch flow {
        case .showDetail: showClientDetail()
        case .showNewClient: showNewClient()
        }
    }
    
    private func showClientDetail() {
        
    }
    
    private func showNewClient() {
        
    }
}

// MARK: Projects flow
extension ProfileFlowController {
    func handleProjectsFlow(_ flow: ProfileFlow.Projects) {
        switch flow {
        case .showDetail: showProjectDetail()
        case .showNewProject: showNewProject()
        }
    }
    
    private func showProjectDetail() {
        
    }
    
    private func showNewProject() {
        
    }
}


