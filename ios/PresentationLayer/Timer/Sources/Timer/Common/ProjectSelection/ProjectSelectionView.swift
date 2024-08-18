//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ProjectSelectionView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let projectSpacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProjectSelectionViewModel
    
    // MARK: - Init
    
    init(viewModel: ProjectSelectionViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if viewModel.state.isEmbedded {
                content
            } else {
                NavigationStack {
                    content
                }
            }
        }
        .searchable(
            text: Binding<String>(
                get: { viewModel.state.searchText },
                set: { text in viewModel.onIntent(.updateSearchText(to: text)) }
            )
        )
        .interactiveDismissDisabled()
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private var content: some View {
        Group {
            switch viewModel.state.viewData {
            case let .data(projects), let .loading(projects):
                ScrollView {
                    LazyVStack {
                        ForEach(0..<projects.count, id: \.self) { idx in
                            let project = projects[idx]
                            
                            Button {
                                viewModel.onIntent(.selectProject(id: project.id))
                            } label: {
                                SelectableProjectView(
                                    project: project,
                                    isSelected: project.id == viewModel.state.selectedProjectId
                                )
                                .skeleton(viewModel.state.viewData.isLoading)
                            }
                        }
                    }
                    .padding(padding)
                    .animateContent(viewModel.state.viewData.isLoading)
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
        .navigationTitle(L10n.project_selection_view_title)
        .toolbar(.visible)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            if !viewModel.state.isEmbedded {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        viewModel.onIntent(.dismiss)
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.save_label) {
                    viewModel.onIntent(.save)
                }
            }
        }
    }
    
    private func localizedEmptyReason(for reason: ViewData<[ProjectPreview]>.EmptyReason) -> String {
        switch reason {
        case .noData: L10n.project_selection_view_no_projects
        case .search: L10n.empty_results
        }
    }
}

#if DEBUG
import Factory
import DependencyInjectionMocks
import Utilities

#Preview {
    Environment.locale = .init(identifier: "cs")
    Container.shared.registerUseCaseMocks()
    
    let vm = ProjectSelectionViewModel(isEmbedded: false)
    return Text("Base View")
        .sheet(isPresented: .constant(true)) {
            ProjectSelectionView(viewModel: vm)
        }
}
#endif
