//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import KMPSharedDomain
import Factory
import SharedDomain

public extension Container {
    
    // MARK: - Auth
    var loginWithCredentialsUseCase: Factory<LoginWithCredentialsUseCase> { self { self.kmp().get(LoginWithCredentialsUseCase.self) } }
    var registerUseCase: Factory<RegisterUseCase> { self { self.kmp().get(RegisterUseCase.self) } }
    var isLoggedInUseCase: Factory<IsLoggedInUseCase> { self { self.kmp().get(IsLoggedInUseCase.self) } }
    var logoutUseCase: Factory<LogoutUseCase> { self { self.kmp().get(LogoutUseCase.self) } }
    var loginWithProviderUseCase: Factory<LoginWithProviderUseCase> { self { self.kmp().get(LoginWithProviderUseCase.self) } }
    
    // MARK: - Timer
    var getTimerEntryUseCase: Factory<GetTimerEntryUseCase> { self { self.kmp().get(GetTimerEntryUseCase.self) } }
    var getTimerEntriesUseCase: Factory<GetTimerEntriesUseCase> { self { self.kmp().get(GetTimerEntriesUseCase.self) } }
    var updateTimerEntryUseCase: Factory<UpdateTimerEntryUseCase> { self { self.kmp().get(UpdateTimerEntryUseCase.self) } }
    var getTimerSummariesUseCase: Factory<GetTimerSummariesUseCase> { self { self.kmp().get(GetTimerSummariesUseCase.self) } }
    var getTimerDataPreviewUseCase: Factory<GetTimerDataPreviewUseCase> { self { self.kmp().get(GetTimerDataPreviewUseCase.self) } }
    var getProjectsUseCase: Factory<GetProjectsUseCase> { self { self.kmp().get(GetProjectsUseCase.self) } }
    var updateTimerDataUseCase: Factory<UpdateTimerDataUseCase> { self { self.kmp().get(UpdateTimerDataUseCase.self) } }
    var addTimerEntryUseCase: Factory<AddTimerEntryUseCase> { self { self.kmp().get(AddTimerEntryUseCase.self) } }
    var deleteTimerEntryUseCase: Factory<DeleteTimerEntryUseCase> { self { self.kmp().get(DeleteTimerEntryUseCase.self) } }
    
    // MARK: - Profile
    var getClientsUseCase: Factory<GetClientsUseCase> { self { self.kmp().get(GetClientsUseCase.self) } }
    var addAndAssignClientUseCase: Factory<AddAndAssignClientUseCase> { self { self.kmp().get(AddAndAssignClientUseCase.self) } }
    var getClientUseCase: Factory<GetClientUseCase> { self { self.kmp().get(GetClientUseCase.self) } }
    var updateClientUseCase: Factory<UpdateClientUseCase> { self { self.kmp().get(UpdateClientUseCase.self) } }
    var removeClientUseCase: Factory<RemoveClientUseCase> { self { self.kmp().get(RemoveClientUseCase.self) } }
    var addAndAssignProjectUseCase: Factory<AddAndAssignProjectUseCase> { self { self.kmp().get(AddAndAssignProjectUseCase.self) } }
    var getProjectPreviewUseCase: Factory<GetProjectPreviewUseCase> { self { self.kmp().get(GetProjectPreviewUseCase.self) } }
    var updateProjectUseCase: Factory<UpdateProjectUseCase> { self { self.kmp().get(UpdateProjectUseCase.self) } }
    var removeProjectUseCase: Factory<RemoveProjectUseCase> { self { self.kmp().get(RemoveProjectUseCase.self) } }
    var deleteUserUseCase: Factory<DeleteUserUseCase> { self { self.kmp().get(DeleteUserUseCase.self) } }
    var getUserEmailUseCase: Factory<GetUserEmailUseCase> { self { self.kmp().get(GetUserEmailUseCase.self) } }
    
    // MARK: - Intent
    var startTimerUseCase: Factory<StartTimerUseCase> { self { self.kmp().get(StartTimerUseCase.self) } }
    var cancelTimerUseCase: Factory<CancelTimerUseCase> { self { self.kmp().get(CancelTimerUseCase.self) } }
    var stopTimerUseCase: Factory<StopTimerUseCase> { self { self.kmp().get(StopTimerUseCase.self) } }
    
    // MARK: - Integrations
    var addIntegrationUseCase: Factory<AddIntegrationUseCase> { self { self.kmp().get(AddIntegrationUseCase.self) } }
    var getIntegrationUseCase: Factory<GetIntegrationUseCase> { self { self.kmp().get(GetIntegrationUseCase.self) } }
    var getIntegrationsUseCase: Factory<GetIntegrationsUseCase> { self { self.kmp().get(GetIntegrationsUseCase.self) } }
    var updateIntegrationUseCase: Factory<UpdateIntegrationUseCase> { self { self.kmp().get(UpdateIntegrationUseCase.self) } }
    var deleteIntegrationUseCase: Factory<DeleteIntegrationUseCase> { self { self.kmp().get(DeleteIntegrationUseCase.self) } }
    var exportToCsvUseCase: Factory<ExportToCsvUseCase> { self { self.kmp().get(ExportToCsvUseCase.self) } }
    var exportToClockifyUseCase: Factory<ExportToClockifyUseCase> { self { self.kmp().get(ExportToClockifyUseCase.self) } }
    
    // MARK: - Purchases
    var getHasFullAccessUseCase: Factory<GetHasFullAccessUseCase> { self { self.kmp().get(GetHasFullAccessUseCase.self) } }
    var getPurchasePackagesUseCase: Factory<GetPurchasePackagesUseCase> { self { self.kmp().get(GetPurchasePackagesUseCase.self) } }
}
