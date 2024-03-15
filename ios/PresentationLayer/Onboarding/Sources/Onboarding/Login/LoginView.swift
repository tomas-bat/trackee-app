//
//  Created by Petr Chmelar on 20.02.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct LoginView: View {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 32
    private let titleSpacing: CGFloat = 0
    private let padding: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: LoginViewModel
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: spacing) {
            Spacer()
            
            // Title
            VStack(spacing: titleSpacing) {
                Text(L10n.login_view_title)
                    .font(AppTheme.Fonts.screenTitle)
                
                Text(L10n.login_view_subtitle)
                    .font(AppTheme.Fonts.body)
            }
            
            // Credentials
            LoginCredentialsView(
                email: Binding<String>(
                    get: { viewModel.state.email },
                    set: { email in viewModel.onIntent(.sync(.onEmailChange(to: email))) }
                ),
                password: Binding<String>(
                    get: { viewModel.state.password },
                    set: { password in viewModel.onIntent(.sync(.onPasswordChange(to: password))) }
                ),
                onLoginTap: {
                    viewModel.onIntent(.async(.login))
                }
            )
            
            Spacer()
            
            Button(L10n.login_view_register_button_title) {
                viewModel.onIntent(.sync(.register))
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(padding)
        .foregroundStyle(AppTheme.Colors.foreground)
        .background(AppTheme.Colors.background)
        .snack(viewModel.snackState)
        .toolbar(.hidden)
        .environment(\.isLoading, viewModel.state.isLoading)
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
        
    let vm = LoginViewModel(flowController: nil)
    return LoginView(viewModel: vm)
}
#endif
