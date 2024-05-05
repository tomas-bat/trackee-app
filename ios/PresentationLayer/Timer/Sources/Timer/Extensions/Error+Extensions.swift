//
//  Created by Tomáš Batěk on 05.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import SharedDomain

extension Error {
    var isClockifyExportError: Bool {
        guard let error = self as? KMPError else { return false }
        switch error.kmpError {
        case let error as BackendError:
            switch onEnum(of: error) {
            case .clockifyInvalidApiKey, .clockifyProjectNotFound, .clockifyWorkspaceNotFound, .clockifyUnknownError: return true
            default: return false
            }
        default: return false
        }
    }
}
