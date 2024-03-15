//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct RegisterView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: RegisterViewModel
    
    // MARK: - Init
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            RegisterCredentialsView(
                email: Binding<String>(
                    get: { viewModel.state.email },
                    set: { email in viewModel.onIntent(.sync(.onEmailChange(to: email))) }
                ),
                newPassword: Binding<String>(
                    get: { viewModel.state.newPassword },
                    set: { newPassword in viewModel.onIntent(.sync(.onNewPasswordChange(to: newPassword))) }
                ),
                verifyPassword: Binding<String>(
                    get: { viewModel.state.verifyPassword },
                    set: { verifyPassword in viewModel.onIntent(.sync(.onVerifyPasswordChange(to: verifyPassword))) }
                ),
                onRegisterTap: {
                    viewModel.onIntent(.async(.register))
                }
            )
            .padding(padding)
            
            Spacer()
        }
        .background(AppTheme.Colors.background)
        .environment(\.isLoading, viewModel.state.isLoading)
        .snack(viewModel.snackState)
        .navigationTitle(L10n.register_view_navigation_title)
        .toolbar(.visible, for: .navigationBar)
        .lifecycle(viewModel)
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = RegisterViewModel()
    return RegisterView(viewModel: vm)
}

#endif
