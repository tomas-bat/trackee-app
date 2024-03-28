//
//  Created by Petr Chmelar on 06.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import KMPSharedDomain
import Factory
import SharedDomain

public extension Container {
    // Koin
    private var kmp: Factory<KMPDependency> { self { KMPKoinDependency() }.singleton }
    
    // Auth
    var loginWithCredentialsUseCase: Factory<LoginWithCredentialsUseCase> { self { self.kmp().get(LoginWithCredentialsUseCase.self) } }
    var registerUseCase: Factory<RegisterUseCase> { self { self.kmp().get(RegisterUseCase.self) } }
    var isLoggedInUseCase: Factory<IsLoggedInUseCase> { self { self.kmp().get(IsLoggedInUseCase.self) } }
    var logoutUseCase: Factory<LogoutUseCase> { self { self.kmp().get(LogoutUseCase.self) } }
    
    // Timer
    var getTimerEntriesUseCase: Factory<GetTimerEntriesUseCase> { self { self.kmp().get(GetTimerEntriesUseCase.self) } }
    var getTimerSummariesUseCase: Factory<GetTimerSummariesUseCase> { self { self.kmp().get(GetTimerSummariesUseCase.self) } }
    var getTimerDataPreviewUseCase: Factory<GetTimerDataPreviewUseCase> { self { self.kmp().get(GetTimerDataPreviewUseCase.self) } }
    var getProjectsUseCase: Factory<GetProjectsUseCase> { self { self.kmp().get(GetProjectsUseCase.self) } }
    var updateTimerDataUseCase: Factory<UpdateTimerDataUseCase> { self { self.kmp().get(UpdateTimerDataUseCase.self) } }
    var addTimerEntryUseCase: Factory<AddTimerEntryUseCase> { self { self.kmp().get(AddTimerEntryUseCase.self) } }
}
