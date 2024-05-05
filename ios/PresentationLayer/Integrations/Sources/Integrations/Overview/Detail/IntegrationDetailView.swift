//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit

struct IntegrationDetailView: View {
    
    // MARK: - Constants
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: IntegrationDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: IntegrationDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state.integrationType {
            case let .data(integrationType), let .loading(integrationType):
                switch integrationType {
                case .csv: csvDetailView
                case .clockify: clockifyDetailView
                }
            case let .error(error):
                ErrorView(
                    error: error,
                    onRetryTap: { viewModel.onIntent(.retry) }
                )
            case .empty:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .skeleton(viewModel.state.integrationType.isLoading)
        .animateContent(viewModel.state.integrationType.isLoading)
        .foregroundStyle(AppTheme.Colors.foreground)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(viewModel.state.label)
        .toolbar(.visible)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.save_label) {
                    viewModel.onIntent(.save)
                }
                .buttonStyle(.loading)
                .environment(\.isLoading, viewModel.state.saveLoading)
            }
        }
        .snack(viewModel.snackState)
        .background(AppTheme.Colors.background)
        .disabled(viewModel.state.saveLoading || viewModel.state.removeLoading)
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { data in viewModel.onIntent(.changeAlertData(to: data)) }
        )) { data in .init(data) }
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private var csvDetailView: some View {
        List {
            titleSection
            
            Section(L10n.integration_detail_export_section_title) {
                navigationButton(
                    L10n.integration_detail_export_data_button_title,
                    action: { viewModel.onIntent(.onExportData) }
                )
            }
            
            if viewModel.state.allowRemove {
                removeButton
            }
        }
    }
    
    private var clockifyDetailView: some View {
        List {
            titleSection
            
            Section(L10n.integration_detail_clockify_section_title) {
                fieldRow(
                    label: L10n.integration_detail_api_key_label,
                    placeholder: L10n.integration_detail_api_key_placeholder,
                    secure: true,
                    info: L10n.integration_detail_api_key_hint,
                    text: Binding<String>(
                        get: { viewModel.state.apiKey ?? "" },
                        set: { key in viewModel.onIntent(.changeApiKey(to: key)) }
                    )
                )
                
                fieldRow(
                    label: L10n.integration_detail_workspace_name_label,
                    placeholder: L10n.integration_detail_workspace_name_placeholder,
                    info: L10n.integration_detail_workspace_hint,
                    text: Binding<String>(
                        get: { viewModel.state.workspaceName ?? "" },
                        set: { name in viewModel.onIntent(.changeWorkspaceName(to: name)) }
                    )
                )
            }
            
            Section(L10n.integration_detail_export_section_title) {
                navigationButton(
                    L10n.integration_detail_export_data_button_title,
                    action: { viewModel.onIntent(.onExportData) }
                )
                
                Toggle(
                    L10n.export_view_auto_export_title,
                    isOn: Binding<Bool>(
                        get: { viewModel.state.autoExport },
                        set: { value in viewModel.onIntent(.changeAutoExport(to: value)) }
                    )
                )
            }
            
            if viewModel.state.allowRemove {
                removeButton
            }
        }
    }
    
    private var titleSection: some View {
        Section(L10n.integration_detail_label_label) {
            fieldRow(
                label: L10n.integration_detail_label_label,
                placeholder: L10n.integration_detail_label_placeholder,
                text: Binding<String>(
                    get: { viewModel.state.label },
                    set: { text in viewModel.onIntent(.changeLabel(to: text)) }
                )
            )
        }
    }
    
    private func fieldRow(
        label: String,
        placeholder: String,
        secure: Bool = false,
        info: String? = nil,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 8) {
            Text(label)
                
            Spacer()
            
            if secure {
                SecureField(placeholder, text: text)
                    .multilineTextAlignment(.trailing)
            } else {
                TextField(placeholder, text: text)
                    .multilineTextAlignment(.trailing)
            }
            
            if let info {
                Button {
                    viewModel.onIntent(.showInfoAlert(with: info))
                } label: {
                    Image(systemSymbol: .infoCircle)
                }
            }
        }
        .foregroundStyle(AppTheme.Colors.foreground)
    }
    
    private func navigationButton(
        _ text: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(text)
                
                Spacer()
                
                Image(systemSymbol: .chevronRight)
            }
        }
    }
    
    private var removeButton: some View {
        Section {
            Button(L10n.integration_detail_remove_integration_button_title) {
                viewModel.onIntent(.remove)
            }
            .buttonStyle(.loading)
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(AppTheme.Colors.destructive)
            .environment(\.isLoading, viewModel.state.removeLoading)
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
    
    let vm = IntegrationDetailViewModel(
        type: .new(integrationType: .clockify),
        flowController: nil
    )
    
    return NavigationStack {
        IntegrationDetailView(viewModel: vm)
    }
}
#endif
