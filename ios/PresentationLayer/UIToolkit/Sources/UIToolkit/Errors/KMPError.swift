//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SharedDomain
import KMPSharedDomain
import Utilities

extension SharedDomain.KMPError: LocalizedError {
    public var errorDescription: String? {
        switch kmpError {
        // MARK: - AuthError
        case is AuthError.EmptyField: return L10n.register_view_fill_all_fields
        case is AuthError.PasswordsDontMatch: return L10n.register_view_passwords_dont_match
        case is AuthError.InvalidLoginCredentials: return L10n.invalid_credentials
        case is AuthError.InvalidEmail: return L10n.invalid_email
        case is AuthError.WeakPassword: return L10n.weak_password
        case is AuthError.EmailAlreadyExist: return L10n.error_email_already_exists
        // MARK: - BackendError
        case let error as BackendError:
            switch onEnum(of: error) {
            case .notAuthorized: return L10n.error_not_authorised
            case .projectNotAssignedToUser: return L10n.error_project_not_assigned_to_user
            case .missingProject: return L10n.error_cannot_stop_and_save_timer_missing_project
            case .missingStartDate: return L10n.error_missing_start_date
            case .clientNotFound: return L10n.error_client_not_found
            case .projectNotFound: return L10n.error_project_not_found
            case let .clockifyProjectNotFound(error): return L10n.export_view_clockify_error_project_not_found(error.projectName ?? "")
            case .clockifyInvalidApiKey: return L10n.export_view_clockify_error_api_key
            case .clockifyUnknownError: return L10n.export_view_clockify_error
            case let .clockifyWorkspaceNotFound(error): return L10n.export_view_clockify_error_workspace_not_found(error.workspaceName ?? "")
            }
        
        // MARK: - CommonError
        case is CommonError.ServerNotReachable: return L10n.error_server_not_available
        default:
            switch Environment.type {
            case .alpha, .beta: return kmpError.message
            case .production: return L10n.unknown_error
            }
        }
    }
}
