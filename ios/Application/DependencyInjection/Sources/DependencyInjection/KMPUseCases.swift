//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import KMPSharedDomain
import Factory
import SharedDomain

public extension Container {
    
    // MARK: - Koin
    private var kmp: Factory<KMPDependency> { self { KMPKoinDependency() }.singleton }
    
    // MARK: - Auth
    var loginWithCredentialsUseCase: Factory<LoginWithCredentialsUseCase> { self { self.kmp().get(LoginWithCredentialsUseCase.self) } }
    var registerUseCase: Factory<RegisterUseCase> { self { self.kmp().get(RegisterUseCase.self) } }
    var isLoggedInUseCase: Factory<IsLoggedInUseCase> { self { self.kmp().get(IsLoggedInUseCase.self) } }
    var logoutUseCase: Factory<LogoutUseCase> { self { self.kmp().get(LogoutUseCase.self) } }
    
    // MARK: - Timer
    var getTimerEntriesUseCase: Factory<GetTimerEntriesUseCase> { self { self.kmp().get(GetTimerEntriesUseCase.self) } }
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
    
    // MARK: - Intent
    var startTimerUseCase: Factory<StartTimerUseCase> { self { self.kmp().get(StartTimerUseCase.self) } }
    var cancelTimerUseCase: Factory<CancelTimerUseCase> { self { self.kmp().get(CancelTimerUseCase.self) } }
    var stopTimerUseCase: Factory<StopTimerUseCase> { self { self.kmp().get(StopTimerUseCase.self) } }
}
