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
                    data: (0..<15).map { id in
                        TimerEntryPreview(
                            id: "\(id)",
                            project: .stub(),
                            client: .stub(),
                            description: "Lorem ipsum dolor sit amet",
                            startedAt: Date(timeIntervalSinceNow: -20_000).asInstant,
                            endedAt: Date.now.asInstant
                        )
                    } as NSArray
                )
            )
        }
        getTimerSummariesUseCase.register {
            GetTimerSummariesUseCaseMock(
                executeReturnValue: ResultSuccess(data: [
                    TimerSummary(component: .today, interval: 12_000),
                    TimerSummary(component: .thisWeek, interval: 123_000)
                ] as NSArray)
            )
        }   
        getTimerDataPreviewUseCase.register {
            GetTimerDataPreviewUseCaseMock(
                executeReturnValue: ResultSuccess(
                    data: TimerDataPreview(
                        status: .active,
                        type: .manual,
                        client: .stub(),
                        project: .stub(),
                        description: "Lorem ipsum dolor sit amet.",
                        startedAt: Date(timeIntervalSinceNow: -20_000).asInstant,
                        availableProjects: .stub
                    )
                )
            )
        }
    }
}
#endif
