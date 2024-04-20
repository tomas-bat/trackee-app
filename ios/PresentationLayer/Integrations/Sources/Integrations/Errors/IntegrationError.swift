//
//  Created by Tomáš Batěk on 19.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SharedDomain
import UIToolkit

extension IntegrationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .nameTooShort: L10n.integration_detail_name_too_short
        case .invalidDateRange: L10n.export_view_invalid_date_range
        case .couldNotSaveFile: L10n.export_view_cannot_save_file
        }
    }
}
