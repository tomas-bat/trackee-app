//
//  Created by Petr Chmelar on 07.10.2023
//  Copyright © 2023 Matee. All rights reserved.
//

#if DEBUG
import CoreLocation
import DependencyInjection
import KMPSharedDomain
import Factory
@testable import SharedDomain
import SharedDomainMocks

public extension Container {
    func registerUseCaseMocks() {
        
        // MARK: - Auth
        loginWithCredentialsUseCase.register {
            LoginWithCredentialsUseCaseMock(
                executeReturnValue: ResultSuccess(data: LoginResponse(idToken: UUID().uuidString))
            )
        }
        registerUseCase.register {
            RegisterUseCaseMock(
                executeReturnValue: ResultSuccess(data: KotlinUnit())
            )
        }
        isLoggedInUseCase.register {
            IsLoggedInUseCaseMock(
                executeReturnValue: ResultSuccess(data: KotlinBoolean(bool: true))
            )
        }
        logoutUseCase.register {
            LogoutUseCaseMock(
                executeReturnValue: ResultSuccess(data: KotlinUnit())
            )
        }
        
        // MARK: - Timer
        getTimerEntriesUseCase.register {
            GetTimerEntriesUseCaseMock(
                executeReturnValue: ResultSuccess(
                    data: [TimerEntryGroup].stub as NSArray
                )
            )
        }
        getTimerSummariesUseCase.register {
            GetTimerSummariesUseCaseMock(
                executeReturnValue: ResultSuccess(data: [TimerSummary].stub as NSArray)
            )
        }   
        getTimerDataPreviewUseCase.register {
            GetTimerDataPreviewUseCaseMock(
                executeReturnValue: ResultSuccess(data: TimerDataPreview.stub)
            )
        }
        getProjectsUseCase.register {
            GetProjectsUseCaseMock(
                executeReturnValue: ResultSuccess(data: [ProjectPreview].stub as NSArray)
            )
        }
        updateTimerDataUseCase.register {
            UpdateTimerDataUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        addTimerEntryUseCase.register {
            AddTimerEntryUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        deleteTimerEntryUseCase.register {
            DeleteTimerEntryUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        
        // MARK: - Profile
        getClientsUseCase.register {
            GetClientsUseCaseMock(executeReturnValue: ResultSuccess(data: [Client].stub as NSArray))
        }
        addAndAssignClientUseCase.register {
            AddAndAssignClientUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        getClientUseCase.register {
            GetClientUseCaseMock(executeReturnValue: ResultSuccess(data: Client.stub()))
        }
        updateClientUseCase.register {
            UpdateClientUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        removeClientUseCase.register {
            RemoveClientUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        addAndAssignProjectUseCase.register {
            AddAndAssignProjectUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        getProjectPreviewUseCase.register {
            GetProjectPreviewUseCaseMock(executeReturnValue: ResultSuccess(data: ProjectPreview.stub()))
        }
        updateProjectUseCase.register {
            UpdateProjectUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        removeProjectUseCase.register {
            RemoveProjectUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
        deleteUserUseCase.register {
            DeleteUserUseCaseMock(executeReturnValue: ResultSuccess(data: KotlinUnit()))
        }
    }
}
#endif
