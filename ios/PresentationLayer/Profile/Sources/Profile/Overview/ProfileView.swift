//
//  Created by Petr Chmelar on 22.05.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit

struct ProfileView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            Section(L10n.profile_view_projects) {
                navigationButton(L10n.profile_view_clients) {
                    viewModel.onIntent(.showClients)
                }
                
                navigationButton(L10n.profile_view_projects) {
                    viewModel.onIntent(.showProjects)
                }
            }
        }
        .foregroundStyle(AppTheme.Colors.foreground)
        .scrollBounceBehavior(.basedOnSize)
        .overlay(alignment: .bottom) {
            Button(L10n.profile_view_logout_button_title) {
                viewModel.onIntent(.logout)
            }
            .buttonStyle(.primary)
            .padding(padding)
        }
        .navigationTitle(L10n.profile_view_title)
        .toolbar(.visible)
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
