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
    case showPaywall(
        paywallViewOrigin: PaywallViewOrigin,
        delegate: PaywallViewModelDelegate?
    )
    
    enum Overview: Equatable {
        case presentOnboarding(message: String?)
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
        case showDetail(clientId: String, projectId: String, delegate: ProjectDetailViewModelDelegate?)
        case showNewProject(delegate: ProjectDetailViewModelDelegate?)
        case dismissModal
        case pop
        
        static func == (lhs: ProfileFlow.Projects, rhs: ProfileFlow.Projects) -> Bool {
            switch (lhs, rhs) {
            case (.showDetail, .showDetail), (.showNewProject, .showNewProject),
                (.dismissModal, .dismissModal), (.pop, .pop): true
            default: false
            }
        }
    }
    
    static func == (lhs: ProfileFlow, rhs: ProfileFlow) -> Bool {
        switch (lhs, rhs) {
        case let (.overview(lhsType), .overview(rhsType)): lhsType == rhsType
        case let (.projects(lhsType), .projects(rhsType)): lhsType == rhsType
        case let (.clients(lhsType), .clients(rhsType)): lhsType == rhsType
        case (.showPaywall, .showPaywall): true
        default: false
        }
    }
}

public protocol ProfileFlowControllerDelegate: AnyObject {
    func presentOnboarding(message: String?)
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
        case let .showPaywall(origin, delegate):
            showPaywall(
                paywallViewOrigin: origin,
                delegate: delegate
            )
        }
    }
    
    private func showPaywall(
        paywallViewOrigin: PaywallViewOrigin,
        delegate: PaywallViewModelDelegate?
    ) {
        let vm = PaywallViewModel(flowController: self)
        vm.delegate = delegate
        let view = PaywallView(
            paywallViewOrigin: paywallViewOrigin,
            viewModel: vm
        )
        let vc = BaseHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
}

// MARK: Overview flow
extension ProfileFlowController {
    func handleOverviewFlow(_ flow: ProfileFlow.Overview) {
        switch flow {
        case let .presentOnboarding(message): presentOnboarding(message: message)
        case .showClients: showClients()
        case .showProjects: showProjects()
        }
    }
    
    private func presentOnboarding(message: String?) {
        delegate?.presentOnboarding(message: message)
    }
    
    private func showClients() {
        let vm = ClientsViewModel(flowController: self)
        let view = ClientsView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showProjects() {
        let vm = ProjectsViewModel(flowController: self)
        let view = ProjectsView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.pushViewController(vc, animated: true)
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
        case let .showDetail(clientId, projectId, delegate): showProjectDetail(clientId: clientId, projectId: projectId, delegate: delegate)
        case let .showNewProject(delegate): showNewProject(delegate: delegate)
        case .dismissModal: navigationController.presentedViewController?.dismiss(animated: true)
        case .pop: pop()
        }
    }
    
    private func showProjectDetail(
        clientId: String,
        projectId: String,
        delegate: ProjectDetailViewModelDelegate?
    ) {
        startProjectDetailFlow(
            editingClientId: clientId,
            editingProejctId: projectId,
            delegate: delegate
        )
    }
    
    private func showNewProject(delegate: ProjectDetailViewModelDelegate?) {
        startProjectDetailFlow(
            editingClientId: nil,
            editingProejctId: nil,
            delegate: delegate
        )
    }
    
    private func startProjectDetailFlow(
        editingClientId: String?,
        editingProejctId: String?,
        delegate: ProjectDetailViewModelDelegate?
    ) {
        let nc = BaseNavigationController()
        let fc = ProjectDetailFlowController(
            editingClientId: editingClientId,
            editingProejctId: editingProejctId,
            delegate: delegate,
            navigationController: nc
        )
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        navigationController.present(nc, animated: true)
    }
}


