//
//  Created by David Kadlček on 14.04.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import SharedDomain


// Auth
public final class LoginWithCredentialsUseCaseMock: UseCaseResultMock, LoginWithCredentialsUseCase {}
public final class RegisterUseCaseMock: UseCaseResultMock, RegisterUseCase {}
public final class IsLoggedInUseCaseMock: UseCaseResultNoParamsMock, IsLoggedInUseCase {}
public final class LogoutUseCaseMock: UseCaseResultNoParamsMock, LogoutUseCase {}
