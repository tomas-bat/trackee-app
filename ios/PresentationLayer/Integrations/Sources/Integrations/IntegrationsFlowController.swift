//
//  Created by Tomáš Batěk on 19/04/2024.
//  Copyright © 2019 Matee. All rights reserved.
//

import SwiftUI
import UIKit
import UIToolkit
import KMPSharedDomain

enum IntegrationsFlow: Flow, Equatable {
    case overview(Overview)
    case detail(Detail)
    case export(Export)
    
    enum Overview: Equatable {
        case showIntegrationDetail(
            integrationId: String,
            delegate: IntegrationDetailViewModelDelegate?
        )
        case showNewIntegration(
            integrationType: IntegrationType,
            delegate: IntegrationDetailViewModelDelegate?
        )
        
        static func == (lhs: IntegrationsFlow.Overview, rhs: IntegrationsFlow.Overview) -> Bool {
            switch (lhs, rhs) {
            case let (.showIntegrationDetail(lhsId, _), .showIntegrationDetail(rhsId, _)): lhsId == rhsId
            case let (.showNewIntegration(lhsType, _), .showNewIntegration(rhsType, _)): lhsType == rhsType
            default: false
            }
        }
    }
    
    enum Detail: Equatable {
        case pop
        case showExport(
            integrationType: IntegrationType,
            apiKey: String?,
            workspaceName: String?
        )
    }
    
    enum Export: Equatable {
        case showExportedFileOptions(url: URL)
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
        case let .detail(flow): handleDetailFlow(flow)
        case let .export(flow): handleExportFlow(flow)
        }
    }
}

// MARK: Overview flow
extension IntegrationsFlowController {
    func handleOverviewFlow(_ flow: IntegrationsFlow.Overview) {
        switch flow {
        case let .showIntegrationDetail(integrationId, delegate): 
            showIntegrationDetail(
                integrationId: integrationId,
                delegate: delegate
            )
        case let .showNewIntegration(integrationType, delegate): 
            showNewIntegration(
                integrationType: integrationType,
                delegate: delegate
            )
        }
    }
    
    private func createIntegrationDetailView(
        type: IntegrationDetailViewModel.`Type`,
        delegate: IntegrationDetailViewModelDelegate?
    ) -> UIViewController {
        let vm = IntegrationDetailViewModel(
            type: type,
            flowController: self
        )
        vm.delegate = delegate
        let view = IntegrationDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    private func showIntegrationDetail(
        integrationId: String,
        delegate: IntegrationDetailViewModelDelegate?
    ) {
        let vc = createIntegrationDetailView(
            type: .edit(integrationId: integrationId),
            delegate: delegate
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showNewIntegration(
        integrationType: IntegrationType,
        delegate: IntegrationDetailViewModelDelegate?
    ) {
        let vc = createIntegrationDetailView(
            type: .new(integrationType: integrationType),
            delegate: delegate
        )
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: Detail flow
extension IntegrationsFlowController {
    func handleDetailFlow(_ flow: IntegrationsFlow.Detail) {
        switch flow {
        case .pop: pop()
        case let .showExport(integrationType, apiKey, workspaceName):
            showExport(
                integrationType: integrationType,
                apiKey: apiKey,
                workspaceName: workspaceName
            )
        }
    }
    
    private func showExport(
        integrationType: IntegrationType,
        apiKey: String?,
        workspaceName: String?
    ) {
        let vm = IntegrationExportViewModel(
            integrationType: integrationType,
            apiKey: apiKey,
            workspaceName: workspaceName,
            flowController: self
        )
        let view = IntegrationExportView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: Export flow
extension IntegrationsFlowController {
    func handleExportFlow(_ flow: IntegrationsFlow.Export) {
        switch flow {
        case let .showExportedFileOptions(url): showExportedFileOptions(url: url)
        }
    }

    private func showExportedFileOptions(url: URL) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        navigationController.present(vc, animated: true)
    }
}
