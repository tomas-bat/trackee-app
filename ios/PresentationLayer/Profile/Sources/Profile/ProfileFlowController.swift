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
        case showDetail(clientId: String, delegate: ClientDetailViewModelDelegate?)
        case showNewClient(delegate: ClientDetailViewModelDelegate?)
        case dismissModal
        
        static func == (lhs: ProfileFlow.Clients, rhs: ProfileFlow.Clients) -> Bool {
            switch (lhs, rhs) {
            case (.showDetail, .showDetail), (.showNewClient, .showNewClient), 
                (.dismissModal, .dismissModal): true
            default: false
            }
        }
    }
    
    enum Projects: Equatable {
        case showDetail(projectId: String)
        case showNewProject
        case dismissModal
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
        case let .showDetail(clientId, delegate): showClientDetail(clientId: clientId, delegate: delegate)
        case let .showNewClient(delegate): showNewClient(delegate: delegate)
        case .dismissModal: navigationController.presentedViewController?.dismiss(animated: true)
        }
    }
    
    private func showClientDetail(clientId: String, delegate: ClientDetailViewModelDelegate?) {
        let vm = ClientDetailViewModel(editingClientId: clientId, flowController: self)
        vm.delegate = delegate
        let view = ClientDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.present(vc, animated: true)
    }
    
    private func showNewClient(delegate: ClientDetailViewModelDelegate?) {
        let vm = ClientDetailViewModel(flowController: self)
        vm.delegate = delegate
        let view = ClientDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.present(vc, animated: true)
    }
}

// MARK: Projects flow
extension ProfileFlowController {
    func handleProjectsFlow(_ flow: ProfileFlow.Projects) {
        switch flow {
        case let .showDetail(projectId): showProjectDetail(projectId: projectId)
        case .showNewProject: showNewProject()
        case .dismissModal: navigationController.presentedViewController?.dismiss(animated: true)
        }
    }
    
    private func showProjectDetail(projectId: String) {
        
    }
    
    private func showNewProject() {
        
    }
}


