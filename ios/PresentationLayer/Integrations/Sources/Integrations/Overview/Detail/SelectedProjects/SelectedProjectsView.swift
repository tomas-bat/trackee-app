//
//  Created by Tomáš Batěk on 11.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit
import KMPSharedDomain

struct SelectedProjectsView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: SelectedProjectsViewModel
    
    // MARK: - Init
    
    init(viewModel: SelectedProjectsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.projects {
            case let .data(projects), let .loading(projects):
                ScrollView {
                    LazyVStack(spacing: spacing) {
                        ForEach(0..<projects.count, id: \.self) { idx in
                            let project = projects[idx]
                            
                            Button {
                                viewModel.onIntent(.selectProject(
                                    clientId: project.client.id,
                                    projectId: project.id
                                ))
                            } label: {
                                SelectableProjectView(
                                    project: project,
                                    isSelected: viewModel.state.selectedProjects.contains(project.asIdentifiableProject)
                                )
                                .skeleton(viewModel.state.projects.isLoading)
                            }
                        }
                    }
                    .animateContent(viewModel.state.projects.isLoading)
                    .padding(padding)
                }
            case let .error(error):
                ErrorView(error: error) {
                    viewModel.onIntent(.retry)
                }
                .padding(padding)
            case let .empty(reason):
                EmptyContentView(text: localizedEmptyReason(for: reason))
                    .padding(padding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
        .navigationTitle(L10n.integration_detail_selected_projects)
        .toolbar(.visible)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.select_label) {
                    viewModel.onIntent(.save)
                }
            }
        }
        .searchable(
            text: Binding<String>(
                get: { viewModel.state.searchText },
                set: { text in viewModel.onIntent(.updateSearchText(to: text)) }
            )
        )
        .snack(viewModel.snackState)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private func localizedEmptyReason(for reason: ViewData<[ProjectPreview]>.EmptyReason) -> String {
        switch reason {
        case .noData: L10n.project_selection_view_no_projects
        case .search: L10n.empty_results
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
    
    let vm = SelectedProjectsViewModel(
        selectedProjects: .stub
    )
    
    return NavigationStack {
        SelectedProjectsView(viewModel: vm)
    }
}
#endif
