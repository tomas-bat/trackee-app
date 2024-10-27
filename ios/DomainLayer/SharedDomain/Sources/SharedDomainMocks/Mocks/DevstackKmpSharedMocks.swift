//
//  Created by David Kadlček on 14.04.2023
//  Copyright © 2023 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import SharedDomain


// MARK: - Auth
public final class LoginWithCredentialsUseCaseMock: UseCaseResultMock, LoginWithCredentialsUseCase {}
public final class RegisterUseCaseMock: UseCaseResultMock, RegisterUseCase {}
public final class IsLoggedInUseCaseMock: UseCaseResultNoParamsMock, IsLoggedInUseCase {}
public final class LogoutUseCaseMock: UseCaseResultNoParamsMock, LogoutUseCase {}

// MARK: - Timer
public final class GetTimerEntryUseCaseMock: UseCaseResultMock, GetTimerEntryUseCase {}
public final class GetTimerEntriesUseCaseMock: UseCaseResultMock, GetTimerEntriesUseCase {}
public final class UpdateTimerEntryUseCaseMock: UseCaseResultMock, UpdateTimerEntryUseCase {}
public final class GetTimerSummariesUseCaseMock: UseCaseResultNoParamsMock, GetTimerSummariesUseCase {}
public final class GetTimerDataPreviewUseCaseMock: UseCaseResultNoParamsMock, GetTimerDataPreviewUseCase {}
public final class GetProjectsUseCaseMock: UseCaseResultNoParamsMock, GetProjectsUseCase {}
public final class UpdateTimerDataUseCaseMock: UseCaseResultMock, UpdateTimerDataUseCase {}
public final class AddTimerEntryUseCaseMock: UseCaseResultMock, AddTimerEntryUseCase {}
public final class DeleteTimerEntryUseCaseMock: UseCaseResultMock, DeleteTimerEntryUseCase {}

// MARK: - Profile
public final class GetClientsUseCaseMock: UseCaseResultNoParamsMock, GetClientsUseCase {}
public final class AddAndAssignClientUseCaseMock: UseCaseResultMock, AddAndAssignClientUseCase {}
public final class GetClientUseCaseMock: UseCaseResultMock, GetClientUseCase {}
public final class UpdateClientUseCaseMock: UseCaseResultMock, UpdateClientUseCase {}
public final class RemoveClientUseCaseMock: UseCaseResultMock, RemoveClientUseCase {}
public final class AddAndAssignProjectUseCaseMock: UseCaseResultMock, AddAndAssignProjectUseCase {}
public final class GetProjectPreviewUseCaseMock: UseCaseResultMock, GetProjectPreviewUseCase {}
public final class UpdateProjectUseCaseMock: UseCaseResultMock, UpdateProjectUseCase {}
public final class RemoveProjectUseCaseMock: UseCaseResultMock, RemoveProjectUseCase {}
public final class DeleteUserUseCaseMock: UseCaseResultNoParamsMock, DeleteUserUseCase {}
public final class GetUserEmailUseCaseMock: UseCaseResultNoParamsMock, GetUserEmailUseCase {}

// MARK: - Intent
public final class StartTimerUseCaseMock: UseCaseResultMock, StartTimerUseCase {}
public final class CancelTimerUseCaseMock: UseCaseResultNoParamsMock, CancelTimerUseCase {}
public final class StopTimerUseCaseMock: UseCaseResultNoParamsMock, StopTimerUseCase {}

// MARK: - Integrations
public final class AddIntegrationUseCaseMock: UseCaseResultMock, AddIntegrationUseCase {}
public final class GetIntegrationUseCaseMock: UseCaseResultMock, GetIntegrationUseCase {}
public final class GetIntegrationsUseCaseMock: UseCaseResultNoParamsMock, GetIntegrationsUseCase {}
public final class UpdateIntegrationUseCaseMock: UseCaseResultMock, UpdateIntegrationUseCase {}
public final class DeleteIntegrationUseCaseMock: UseCaseResultMock, DeleteIntegrationUseCase {}
public final class ExportToCsvUseCaseMock: UseCaseResultMock, ExportToCsvUseCase {}
public final class ExportToClockifyUseCaseMock: UseCaseResultMock, ExportToClockifyUseCase {}

// MARK: - Purchases
public final class GetHasFullAccessUseCaseMock: UseCaseResultNoParamsMock, GetHasFullAccessUseCase {}
