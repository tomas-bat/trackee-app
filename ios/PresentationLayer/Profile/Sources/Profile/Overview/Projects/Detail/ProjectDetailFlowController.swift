//
//  Created by Tomáš Batěk on 04.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import UIToolkit
import UIKit

public enum ProjectDetailFlow: Flow, Equatable {
    case showClientSelection(
        selectedClientId: String?,
        delegate: ClientSelectionViewModelDelegate?
    )
    case dismiss
    case pop
    
    public static func == (lhs: ProjectDetailFlow, rhs: ProjectDetailFlow) -> Bool {
        switch (lhs, rhs) {
        case (.showClientSelection, .showClientSelection), (.dismiss, .dismiss), (.pop, .pop): true
        default: false
        }
    }
}

public final class ProjectDetailFlowController: FlowController {
    
    private let editingClientId: String?
    private let editingProjectId: String?
    private let delegate: ProjectDetailViewModelDelegate?
    
    public init(
        editingClientId: String?,
        editingProjectId: String?,
        delegate: ProjectDetailViewModelDelegate?,
        navigationController: UINavigationController
    ) {
        self.editingClientId = editingClientId
        self.editingProjectId = editingProjectId
        self.delegate = delegate
        super.init(navigationController: navigationController)
    }
 
    public override func setup() -> UIViewController {
        let vm = ProjectDetailViewModel(
            editingClientId: editingClientId,
            editingProjectId: editingProjectId,
            flowController: self
        )
        vm.delegate = delegate
        let view = ProjectDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.isModalInPresentation = true
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
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
