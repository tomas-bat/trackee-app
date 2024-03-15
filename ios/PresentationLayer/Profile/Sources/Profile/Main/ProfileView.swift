//
//  Created by Petr Chmelar on 22.05.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("You are logged in.")
            
            Button("Logout") {
                viewModel.onIntent(.logout)
            }
        }
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory

#Preview {
    Container.shared.registerUseCaseMocks()
    
    let vm = ProfileViewModel(flowController: nil)
    return ProfileView(viewModel: vm)
}
#endif
