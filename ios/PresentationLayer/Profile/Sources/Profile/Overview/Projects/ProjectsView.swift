//
//  Created by Tomáš Batěk on 02.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ProjectsView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProjectsViewModel
    
    // MARK: - Init
    
    init(viewModel: ProjectsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.projects {
            case let .data(projects), let .loading(projects):
                ScrollView {
                    LazyVStack(spacing: spacing) {
                        ForEach(projects) { project in
                            ProjectRowView(project: project) {
                                viewModel.onIntent(
                                    .showProjectDetail(
                                        clientId: project.client.id,
                                        projectId: project.id
                                    )
                                )
                            }
                            .skeleton(viewModel.state.projects.isLoading)
                        }
                    }
                    .animateContent(viewModel.state.projects.isLoading)
                    .padding(padding)
                }
                .scrollBounceBehavior(.basedOnSize)
            case let .error(error):
                ErrorView(error: error) {
                    viewModel.onIntent(.retry)
                }
                .padding(padding)
            case .empty:
                EmptyContentView()
                    .padding(padding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
        .navigationTitle(L10n.projects_view_title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.onIntent(.addProject)
                } label: {
                    Image(systemSymbol: .plus)
                }
            }
        }
        .searchable(
            text: Binding<String>(
                get: { viewModel.state.searchText },
                set: { text in viewModel.onIntent(.updateSearchText(to: text)) }
            )
        )
        .lifecycle(viewModel)
    }
}

#if DEBUG
import Factory
import DependencyInjectionMocks
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = ProjectsViewModel()
    return NavigationStack {
        ProjectsView(viewModel: vm)
    }
}

#endif
