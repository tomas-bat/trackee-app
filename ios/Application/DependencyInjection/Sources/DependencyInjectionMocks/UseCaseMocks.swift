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
    }
}
#endif
