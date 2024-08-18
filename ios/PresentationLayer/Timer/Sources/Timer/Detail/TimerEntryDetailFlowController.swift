//
//  Created by Tomáš Batěk on 18.08.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit
import UIKit
import KMPSharedDomain

enum TimerEntryDetailFlow: Flow, Equatable {
    case showProjectSelection(
        selectedProjectId: String?,
        delegate: ProjectSelectionViewModelDelegate?
    )
    case pop
    case dismiss
    
    static func == (lhs: TimerEntryDetailFlow, rhs: TimerEntryDetailFlow) -> Bool {
        switch (lhs, rhs) {
        case let (.showProjectSelection(lhsProjectId, _), .showProjectSelection(rhsProjectId, _)):
            lhsProjectId == rhsProjectId
        case (.dismiss, .dismiss): true
        case (.pop, .pop): true
        default: false
        }
    }
}

protocol TimerEntryDetailFlowControllerDelegate: AnyObject {
    func didUpdateEntry() async
}

final class TimerEntryDetailFlowController: FlowController {
    
    public weak var delegate: TimerEntryDetailFlowControllerDelegate?
    
    private let entryId: String
    
    init(
        entryId: String,
        navigationController: UINavigationController
    ) {
        self.entryId = entryId
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = TimerEntryDetailViewModel(entryId: entryId, flowController: self)
        vm.delegate = self
        let view = TimerEntryDetailView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        return vc
    }
    
    override func handleFlow(_ flow: Flow) {
        switch flow {
        case let flow as TimerFlow:
            switch flow {
            case let .projectSelection(flow):
                switch flow {
                case .pop: pop()
                case .dismiss: dismiss()
                }
            default: ()
            }
        case let flow as TimerEntryDetailFlow:
            switch flow {
            case let .showProjectSelection(selectedProjectId, delegate):
                showProjectSelection(
                    selectedProjectId: selectedProjectId,
                    delegate: delegate
                )
            case .pop: pop()
            case .dismiss: dismiss()
            }
        default: ()
        }
        
    }
    
    private func showProjectSelection(
        selectedProjectId: String?,
        delegate: ProjectSelectionViewModelDelegate?
    ) {
        let vm = ProjectSelectionViewModel(
            selectedProjectId: selectedProjectId,
            isEmbedded: true,
            flowController: self
        )
        vm.delegate = delegate
        let view = ProjectSelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - TimerEntryDetailViewModelDelegate

extension TimerEntryDetailFlowController: TimerEntryDetailViewModelDelegate {
    func didUpdateEntry() async {
        await delegate?.didUpdateEntry()
    }
}

