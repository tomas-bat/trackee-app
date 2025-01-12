//
//  Created by Petr Chmelar on 22.05.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit

struct ProfileView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let imageSize: CGFloat = 64
    private let spacing: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            switch viewModel.state.email {
            case let .data(email), let .loading(email):
                HStack(spacing: spacing) {
                    Asset.Images.user.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                    
                    Text(email)
                        .font(AppTheme.Fonts.headline)
                        .multilineTextAlignment(.leading)
                        .skeleton(viewModel.state.email.isLoading)
                }
            case let .error(error):
                ErrorView(error: error)
            case .empty:
                EmptyView()
            }
            
            Section(L10n.profile_view_projects) {
                navigationButton(L10n.profile_view_clients) {
                    viewModel.onIntent(.showClients)
                }
                
                navigationButton(L10n.profile_view_projects) {
                    viewModel.onIntent(.showProjects)
                }
            }
            
            Section {
                Button(L10n.profile_view_restore_purchases) {
                    viewModel.onIntent(.restorePurchases)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.loading)
                .environment(\.isLoading, viewModel.state.restorePurchasesLoading)
                
                if viewModel.state.showAlphaFullAccessSwitch {
                    Toggle(
                        isOn: Binding<Bool>(
                            get: { viewModel.state.alphaHasFullAccess },
                            set: { _ in viewModel.onIntent(.toggleAlphaFullAccess) }
                        )
                    ) {
                        Text(L10n.profile_view_alpha_full_access_toggle_title)
                    }
                }
            }
            
            Section {
                Button(L10n.profile_view_delete_user_button_title) {
                    viewModel.onIntent(.deleteAccount)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.loading)
                .foregroundStyle(AppTheme.Colors.destructive)
                .environment(\.isLoading, viewModel.state.deleteLoading)
            }
        }
        .foregroundStyle(AppTheme.Colors.foreground)
        .scrollBounceBehavior(.basedOnSize)
        .overlay(alignment: .bottom) {
            Button(L10n.profile_view_logout_button_title) {
                viewModel.onIntent(.logout)
            }
            .environment(\.isLoading, viewModel.state.logoutLoading)
            .buttonStyle(.primary)
            .padding(padding)
        }
        .navigationTitle(L10n.profile_view_title)
        .toolbar(.visible)
        .snack(viewModel.snackState)
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { data in viewModel.onIntent(.changeAlertData(to: data)) }
        )) { data in .init(data) }
        .disabled(viewModel.state.disabled)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private func navigationButton(_ text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(text)
                
                Spacer()
                
                Image(systemSymbol: .chevronRight)
            }
        }
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Container.shared.registerUseCaseMocks()
    Environment.locale = .init(identifier: "cs")
    
    let vm = ProfileViewModel(flowController: nil)
    return NavigationStack {
        ProfileView(viewModel: vm)
    }
}
#endif
