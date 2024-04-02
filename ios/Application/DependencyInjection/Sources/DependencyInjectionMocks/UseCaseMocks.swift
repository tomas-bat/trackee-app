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
    }
}
#endif
