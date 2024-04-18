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
        case is AuthError.EmptyField: L10n.register_view_fill_all_fields
        case is AuthError.PasswordsDontMatch: L10n.register_view_passwords_dont_match
        // MARK: - BackendError
        case is BackendError.NotAuthorized: L10n.error_not_authorised
        case is BackendError.ProjectNotAssignedToUser: L10n.error_project_not_assigned_to_user
        case is BackendError.MissingProject: L10n.error_cannot_stop_and_save_timer_missing_project
        // MARK: - CommonError
        case is CommonError.ServerNotReachable: L10n.error_server_not_available
        default:
            switch Environment.type {
            case .alpha, .beta: kmpError.message
            case .production: L10n.unknown_error
            }
        }
    }
}
