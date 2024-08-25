//
//  Created by Tomáš Batěk on 20.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import DependencyInjection
import Factory
import SharedDomain
import SwiftUI
import UIToolkit
import Utilities
import KMPSharedDomain
import SharedDomainMocks

final class IntegrationExportViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    @Injected(\.exportToCsvUseCase) private var exportToCsvUseCase
    @Injected(\.exportToClockifyUseCase) private var exportToClockifyUseCase
    
    // MARK: - Stored properties
    
    private let integrationId: String
    private let integrationType: IntegrationType
    private let apiKey: String?
    private let workspaceName: String?
    
    // MARK: - Init
    
    init(
        integrationId: String,
        integrationType: IntegrationType,
        apiKey: String?,
        workspaceName: String?,
        flowController: FlowController? = nil
    ) {
        self.integrationId = integrationId
        self.integrationType = integrationType
        self.apiKey = apiKey
        self.workspaceName = workspaceName
        self.flowController = flowController
    }
    
    // MARK: - Lifecycle
    
    
    // MARK: - State
    
    @Published private(set) var state = State()
    @Published private(set) var snackState = SnackState<InfoErrorSnackVisuals>()
    
    struct State {
        var fromDate: Date = .now
        var toDate: Date = .now
        var exportLoading = false
    }
    
    // MARK: - Intent
    
    enum Intent {
        case changeFromDate(to: Date)
        case changeToDate(to: Date)
        case export
    }
    
    func onIntent(_ intent: Intent) {
        executeTask(Task {
            switch intent {
            case let .changeFromDate(date): state.fromDate = date
            case let .changeToDate(date): state.toDate = date
            case .export: await export()
            }
        })
    }
    
    // MARK: - Private
    
    private func export() async {
        state.exportLoading = true
        defer { state.exportLoading = false }
        
        await execute {
            guard state.fromDate <= state.toDate else {
                throw IntegrationError.invalidDateRange
            }
            
            switch integrationType {
            case .csv: try await exportCsv()
            case .clockify: try await exportClockify()
            }
        } onError: { error in
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        snackState.currentData?.dismiss()
        snackState.showSnackSync(
            .error(
                message: error.localizedDescription,
                actionLabel: nil,
                duration: 5
            )
        )
    }
    
    private func exportCsv() async throws {
        let params = ExportToCsvUseCaseParams(
            integrationId: integrationId,
            from: state.fromDate.asInstant,
            to: state.toDate.asInstant
        )
        let csv: String = try await exportToCsvUseCase.execute(params: params)
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("export.csv")
        
        try csv.write(to: url, atomically: true, encoding: .utf8)
        
        flowController?.handleFlow(IntegrationsFlow.export(.showExportedFileOptions(url: url)))
    }
    
    private func exportClockify() async throws {
        guard let apiKey else { throw IntegrationError.missingApiKey }
        
        let params = ExportToClockifyUseCaseParams(
            integrationId: integrationId,
            request: NewClockifyExportRequest(
                apiKey: apiKey,
                workspaceName: workspaceName,
                from: state.fromDate.asInstant,
                to: state.toDate.asInstant
            )
        )
        try await exportToClockifyUseCase.execute(params: params)
        
        snackState.currentData?.dismiss()
        snackState.showSnackSync(.info(message: L10n.export_view_success_title))
    }
}
