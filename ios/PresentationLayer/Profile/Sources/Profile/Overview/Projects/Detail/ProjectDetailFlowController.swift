//
//  Created by Tomáš Batěk on 04.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import UIToolkit
import UIKit

enum ProjectDetailFlow: Flow, Equatable {
    case showClientSelection(
        selectedClientId: String?,
        delegate: ClientSelectionViewModelDelegate?
    )
    case dismiss
    case pop
    
    static func == (lhs: ProjectDetailFlow, rhs: ProjectDetailFlow) -> Bool {
        switch (lhs, rhs) {
        case (.showClientSelection, .showClientSelection), (.dismiss, .dismiss), (.pop, .pop): true
        default: false
        }
    }
}

final class ProjectDetailFlowController: FlowController {
    
    private let editingClientId: String?
    private let editingProejctId: String?
    private let delegate: ProjectDetailViewModelDelegate?
    
    init(
        editingClientId: String?,
        editingProejctId: String?,
        delegate: ProjectDetailViewModelDelegate?,
        navigationController: UINavigationController
    ) {
        self.editingClientId = editingClientId
        self.editingProejctId = editingProejctId
        self.delegate = delegate
        super.init(navigationController: navigationController)
    }
 
    override func setup() -> UIViewController {
        let vm = ProjectDetailViewModel(
            editingClientId: editingClientId,
            editingProjectId: editingProejctId,
            flowController: self
        )
        vm.delegate = delegate
        let view = ProjectDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.isModalInPresentation = true
        
        return vc
    }
    
    override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? ProjectDetailFlow else { return }
        switch flow {
        case let .showClientSelection(selectedClientId, delegate):
            showClientSelection(
                selectedClientId: selectedClientId,
                delegate: delegate
            )
        case .dismiss: dismiss()
        case .pop: pop()
        }
    }
    
    private func showClientSelection(
        selectedClientId: String?,
        delegate: ClientSelectionViewModelDelegate?
    ) {
        let vm = ClientSelectionViewModel(
            selectedClientId: selectedClientId,
            flowController: self
        )
        vm.delegate = delegate
        let view = ClientSelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
