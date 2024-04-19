//
//  Created by Tomáš Batěk on 03.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import KMPSharedDomain
import UIToolkit

struct ProjectDetailView: View {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 8
    private let labelMinWidth: CGFloat = 80
    private let imageSize: CGFloat = 17
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProjectDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: ProjectDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            Section {
                clientRow
                
                fieldRow(
                    label: L10n.project_detail_view_name_label,
                    placeholder: L10n.project_detail_view_name_placeholder,
                    text: Binding<String>(
                        get: { viewModel.state.name },
                        set: { name in viewModel.onIntent(.changeName(to: name)) }
                    )
                )
                
                typeRow
            }
            
            if !viewModel.state.isCreating {
                Section {
                    Button(L10n.project_detail_remove_project) {
                        viewModel.onIntent(.remove)
                    }
                    .buttonStyle(.loading)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(AppTheme.Colors.destructive)
                    .environment(\.isLoading, viewModel.state.removeLoading)
                }
            }
        }
        .skeleton(viewModel.state.isLoading)
        .animateContent(viewModel.state.isLoading)
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
        .navigationTitle(navigationTitle)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(L10n.cancel) {
                    viewModel.onIntent(.cancel)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.save_label) {
                    viewModel.onIntent(.save)
                }
                .buttonStyle(.loading)
                .environment(\.isLoading, viewModel.state.saveLoading)
            }
        }
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in viewModel.onIntent(.changeAlertData(to: alertData)) }
        )) { alertData in .init(alertData) }
        .snack(viewModel.snackState)
        .disabled(viewModel.state.saveLoading || viewModel.state.removeLoading)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private var navigationTitle: String {
        viewModel.state.isCreating ? L10n.project_detail_new_project_title : L10n.project_detail_edit_project_title
    }
    
    private func fieldRow(
        label: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 8) {
            Text(label)
                
            Spacer()
            
            TextField(placeholder, text: text)
                .multilineTextAlignment(.trailing)
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
    
    private var clientRow: some View {
        HStack(spacing: spacing) {
            Text(L10n.project_detail_view_client_label)
            
            Spacer()
            
            Button {
                viewModel.onIntent(.selectClient)
            } label: {
                HStack(spacing: spacing) {
                    Text(viewModel.state.client?.name ?? L10n.project_detail_view_client_none_selected)
                        .foregroundStyle(AppTheme.Colors.foregroundSecondary)
                        .if(viewModel.state.client == nil) { $0.italic() }
                    
                    Image(systemSymbol: .chevronRight)
                }
            }
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
    
    private var typeRow: some View {
        Picker(
            L10n.project_detail_view_type_label,
            selection: Binding<ProjectType?>(
                get: { viewModel.state.projectType },
                set: { type in viewModel.onIntent(.changeProjectType(to: type)) }
            )
        ) {
            Text(L10n.project_detail_view_type_none)
                .tag(nil as ProjectType?)
            
            ForEach(ProjectType.allCases) { type in
                HStack(spacing: spacing) {
                    Text(type.name)
                    
                    type.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                }
                .tag(type as ProjectType?)
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
    
    let vm = ProjectDetailViewModel(
        editingClientId: UUID().uuidString,
        editingProjectId: UUID().uuidString
    )
    
    return Text("Base view")
        .sheet(isPresented: .constant(true)) {
            ProjectDetailView(viewModel: vm)
        }
}
#endif
