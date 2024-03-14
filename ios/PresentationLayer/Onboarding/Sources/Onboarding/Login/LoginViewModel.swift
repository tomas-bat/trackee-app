//
//  Created by Petr Chmelar on 20.02.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities

final class LoginViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: Dependencies
    private weak var flowController: FlowController?
    
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()

    init(flowController: FlowController?) {
        self.flowController = flowController
        super.init()
        
        if Environment.flavor == .debug && Environment.type == .alpha {
            
        }
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
    }
    
    // MARK: State
    
    @Published private(set) var state: State = State()

    struct State {
        var alert: AlertData?
    }
    
    // MARK: Intent
    enum Intent {

    }

    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {

            }
        })
    }
    
    // MARK: Private
    
    private func dismissAlert() {
        state.alert = nil
    }
}
