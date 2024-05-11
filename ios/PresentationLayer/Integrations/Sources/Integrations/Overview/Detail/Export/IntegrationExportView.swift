//
//  Created by Tomáš Batěk on 20.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI
import UIToolkit

struct IntegrationExportView: View {
    
    // MARK: - Constants
    
    private let datePickerDisplayedComponents: DatePickerComponents = [.date]
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: IntegrationExportViewModel
    
    // MARK: - Init
    
    init(viewModel: IntegrationExportViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            Section(L10n.export_view_interval_section_title) {
                DatePicker(
                    L10n.export_view_from_label,
                    selection: fromDate,
                    displayedComponents: datePickerDisplayedComponents
                )
                
                DatePicker(
                    L10n.export_view_to_label,
                    selection: toDate,
                    displayedComponents: datePickerDisplayedComponents
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(AppTheme.Colors.foreground)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(L10n.export_view_title)
        .toolbar(.visible)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(L10n.export_view_export_button_title) {
                    viewModel.onIntent(.export)
                }
                .buttonStyle(.loading)
                .environment(\.isLoading, viewModel.state.exportLoading)
            }
        }
        .snack(viewModel.snackState)
        .background(AppTheme.Colors.background)
        .disabled(viewModel.state.exportLoading)
        .lifecycle(viewModel)
    }
    
    // MARK: - Private
    
    private var fromDate: Binding<Date> {
        Binding<Date>(
            get: { viewModel.state.fromDate },
            set: { date in viewModel.onIntent(.changeFromDate(to: date)) }
        )
    }
    
    private var toDate: Binding<Date> {
        Binding<Date>(
            get: { viewModel.state.toDate },
            set: { date in viewModel.onIntent(.changeToDate(to: date)) }
        )
    }
}

#if DEBUG
import DependencyInjectionMocks
import Factory
import Utilities

#Preview {
    Container.shared.registerUseCaseMocks()
    Environment.locale = .init(identifier: "cs")
    
    let vm = IntegrationExportViewModel(
        integrationType: .clockify,
        apiKey: .randomString(),
        workspaceName: .randomString(),
        flowController: nil
    )
    
    return NavigationStack {
        IntegrationExportView(viewModel: vm)
    }
}
#endif
