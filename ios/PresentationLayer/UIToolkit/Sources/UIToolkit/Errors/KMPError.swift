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
        case let error as AuthError:
            switch onEnum(of: error) {
            case .emptyField: return L10n.register_view_fill_all_fields
            case .passwordsDontMatch: return L10n.register_view_passwords_dont_match
            case .invalidLoginCredentials: return L10n.invalid_credentials
            case .invalidEmail: return L10n.invalid_email
            case .weakPassword: return L10n.weak_password
            case .emailAlreadyExist: return L10n.error_email_already_exists
            case .noAccessToken: return L10n.error_no_access_token
            case .noCurrentUser: return L10n.error_no_current_user
            }
            
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
            case .serviceUnavailable: return L10n.error_service_unavailable
            }
        
        // MARK: - CommonError
        case let error as CommonError:
            switch onEnum(of: error) {
            case .noNetworkConnection: return L10n.error_no_internet_connection
            case .serverNotReachable: return L10n.error_server_not_available
            case .timeout: return L10n.error_request_timeout
            case .noUserLoggedIn: return L10n.error_not_authorised
            case .unknown: return L10n.unknown_error
            }
            
        default:
            switch Environment.type {
            case .alpha, .beta: return kmpError.message
            case .production: return L10n.unknown_error
            }
        }
    }
}
